FROM sinuraya:7.1.6-apache
ARG DB_NAME
ARG DB_USER 
ARG DB_PASSWORD 
ARG DB_HOST 
ARG JWT_SECRET 
ARG BASE_URL
ARG MIDDLE_URL
ARG RELAXED

RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev
RUN docker-php-ext-install zip
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
COPY ./app /var/www/html
WORKDIR /var/www/html
RUN composer install
RUN (echo DB_NAME=$DB_NAME \
&& echo DB_USER=$DB_USER \
&& echo DB_PASSWORD=$DB_PASSWORD \
&& echo DB_HOST=$DB_HOST \
&& echo JWT_SECRET=$JWT_SECRET \
&& echo BASE_URL=$BASE_URL \
&& echo MIDDLE_URL=$MIDDLE_URL \
&& echo RELAXED=$RELAXED ) > ".env"
