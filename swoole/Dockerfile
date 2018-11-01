FROM alpine

Maintainer BestKind ( http://github.com/BestKind/ )

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories \
#&& echo "nameserver 8.8.8.8" >> /etc/resolv.conf 
&& apk update && apk upgrade \
&& apk add php7 \
&& apk add php7-opcache \
&& ln -fs /usr/bin/php7 /usr/bin/php \
&& rm -rf /var/cache/apk/ && mkdir /var/cache/apk && rm -rf /tmp/*

ADD build_swoole_so.sh /root/

RUN sh /root/build_swoole_so.sh

ADD php.ini /etc/php7/

CMD ["top", "-b"]
#RUN php -i && php -m
