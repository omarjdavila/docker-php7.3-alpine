## Optimized for laravel 5.x
**PHP 7.3**

### ENV:

* **WORKDIR**
Docker workdir. Default: ```/www```

### VOLUMES:
>   php-fpm config:
>   - ```/php/config:/usr/local/etc:ro```
>   - ```/php/socket:/var/run/php```
>   - ```/php/supervisord.conf:/etc/supervisord.conf:ro```

### docker-compose.yml (example):
```yml
php:
    name: php_project
    hostname: php_project
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://nginx/status/fpm"]
    image: odavila/php
    restart: unless-stopped
    volumes:
      - ./:/www
      - ./php/config:/usr/local/etc:ro
      - ./php/socket:/var/run/php
      - ./php/supervisord.conf:/etc/supervisord.conf:ro
```

## COMMANDS: 

#### Composer:
You can run composer:

    docker run --rm -it --user $(id -u ${USER}):$(id -g ${USER}) -v $(pwd):/app composer install

#### Artisan

You can run artisan:

	docker exec -it php_project php artisan key:generate
	docker exec -it php_project php artisan migrate

## Queue

[Supervisor](http://supervisord.org) is used to automatically run Laravel queue workers. You can [customize the configuration](https://laravel.com/docs/master/queues#supervisor-configuration) by modifying `php/supervisord.conf` file.
