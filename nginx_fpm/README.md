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