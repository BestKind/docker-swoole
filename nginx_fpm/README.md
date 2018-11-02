# docker-nginx-fpm

## 标准

一般来说 `php` 的 `web` 环境标配是 `lnmp`，故文章以 `lnmp` 为标准搭建

## 配置方案

因为是以 `lnmp` 为标准，所以通过 `docker-compose` 来配置。`docker-compose` 通过 `YAML` 文件来定义项目，项目中包含单个或多个容器服务；一般配置文件名为：`docker-compose.yml`

## 目录结构

- nginx_fpm
	- code
		- index.php
	- services
		- nginx
		- php
		- mysql
	- docker-compose.yml

## MySQL

给 `MySQL` 添加一个数据卷，将其声称的数据保存在本机上，下次创建容器的时候，可以继续使用已有的数据

## PHP

定义一个解释 `PHP` 的服务，使用自行创建的服务镜像，*注意镜像软件使用的源的问题*
配置文件暂时就写这么多，有需要可以自行添加，添加完重新 `build` 一下即可

## nginx

将配置、日志以及代码都映射到本机数据卷

## xdebug

`xdebug` 属于常用的调试工具，使用 docker 之后，相关的配置方式需要做一个简单的修改，主要有以下几个步骤：

1. 在 `php-fpm` 中安装 `xdebug` 扩展，这个是基础，没什么好说的
2. 单独配置一个 xdebug.ini 文件，其中内容可以参考 `services->php->xdebug.ini`
3. 找一个本机没有被占用的端口，修改为 `xdebug` 的端口，需要与 第 `2` 步中 配置的 `xdebug.remote_port` 值一致，并将 `PHPSTORM` 的 `File->Preference->Languages & Frameworks->PHP->Debug` 配置里面的 `Xdebug` 中的 `Xdebug port` 值修改为该值
4. 在 `PHPSTORM` 的 `File->Preference->Languages & Frameworks->PHP->Servers` 中配置一个服务，其中 `name` 可以不限制，`host` 为远程配置的 域名地址，同时启用并映射 路径关系（其中 `name` 和 `host` 最好保持一致，方便记忆和理解）
5. 在 `PHPSTORM` 的 `RUN->Edit Configurations` 中新增一个 `PHP Remote Debug`，`name` 与第 `4` 步描述的 `name` 同理，`server` 选择第 `4` 步中创建的 `server`，IDE key 与第 `2` 步中配置的 `xdebug.idekey` 值保持一致

以上为所有的相关配置，配置完成后，开启监听即可进行 `debug`

