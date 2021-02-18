#!/bin/bash

export MYSQL_PWD=$MYSQL_ROOT_PASSWORD;
mysql -h mysql-master -u root -e "SHOW MASTER STATUS" | awk '{print $1}' | sed -n '2p'

touch best.txt

echo "bestkind" > best.txt
