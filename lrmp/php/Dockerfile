FROM php:7.4-fpm-alpine
MAINTAINER bestkind

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 更新 apt-get 源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装依赖，核心扩展，pecl 扩展，git，composer 工具
RUN apk update && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        imagemagick-dev \
        libtool \
        libzip-dev \
        libxml2-dev \
        postgresql-dev \
        sqlite-dev \
        libmcrypt-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        icu \
        icu-dev \
    && apk add --no-cache \
        curl \
        git \
        imagemagick \
        mysql-client \
        postgresql-libs \
    && pecl install imagick \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install \
        curl \
        # mbstring \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        tokenizer \
        xml \
        zip \
        bcmath \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl \
    && pecl install -o -f redis \
    # && pecl install xdebug \
    && rm -rf /tmp/pear \
    # && docker-php-ext-enable xdebug \
    && docker-php-ext-enable redis

RUN mkdir -p /www/project
RUN mkdir -p /www/logs
RUN chown -R www-data:www-data /www/project
RUN chown -R www-data:www-data /www/logs
RUN chmod -R 777 /www/logs

# 安装composer并允许 root 用户运行
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_HOME=/usr/local/share/composer
RUN mkdir -p /usr/local/share/composer \
    && php -r "copy('https://install.phpcomposer.com/installer', './composer-setup.php');" \
    && php ./composer-setup.php && mv ./composer.phar /usr/local/bin/composer \
    && rm -rf composer-setup.php composer.phar \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# 开放 9000 端口
EXPOSE 9000
