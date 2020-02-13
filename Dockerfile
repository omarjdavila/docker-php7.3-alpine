FROM php:7.3-fpm-alpine

ENV REDIS_VERSION 4.0.2

# Install PHP extension dependencies
RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apk add --update --upgrade bash git curl openssl

# Install Redis PHP extension dependencies
RUN curl -L -o redis.tar.gz https://github.com/phpredis/phpredis/archive/$REDIS_VERSION.tar.gz && \
tar xfz redis.tar.gz && \
rm -r redis.tar.gz && \
mkdir -p /usr/src/php/ext && \
mv phpredis-* /usr/src/php/ext/redis && \
docker-php-ext-install redis

# Installk AWS SSM
RUN wget https://github.com/Droplr/aws-env/raw/v0.4/bin/aws-env-linux-amd64 -O /bin/aws-env && \
  chmod +x /bin/aws-env

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  php composer-setup.php \
  php -r "unlink('composer-setup.php');" \
  mv composer.phar /usr/local/bin/composer

# Install PHPcs
RUN wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar && \
  mv phpcs.phar /usr/local/bin/phpcs && \
  chmod +x /usr/local/bin/phpcs

# Install Supervisor
RUN apk --no-cache add supervisor && mkdir /etc/supervisor.d

# Create user and group
RUN addgroup -S -g 1000 www && adduser -S -D -u 1000 -G www www

# Create workdir
RUN mkdir /www && touch /www/docker-volume-not-mounted && chown www:www /www
WORKDIR /www

# Supervisor will run PHP-FPM and Laravel queue workers
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
