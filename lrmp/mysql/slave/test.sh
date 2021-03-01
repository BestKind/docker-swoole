#!/usr/bin/env sh

export MYSQL_PWD=$MYSQL_ROOT_PASSWORD;
curLog=`mysql -h mysql-master -u root -e "SHOW MASTER STATUS" | awk '{print $1}' | sed -n '2p'`
curPos=`mysql -h mysql-master -u root -e "SHOW MASTER STATUS" | awk '{print $2}' | sed -n '2p'`

CHANGE MASTER TO MASTER_HOST='10.10.3.1', MASTER_USER='app', MASTER_PORT=3306, MASTER_PASSWORD='123456', MASTER_LOG_FILE='$curLog', MATER_LOG_POS='$curPos';
start slave;
touch best.txt

echo $curLog > best.txt
echo $curPos > best.txt
