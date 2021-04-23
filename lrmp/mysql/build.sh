#!/bin/bash

#################### 变量定义 ####################
mysql_user="app"    # 主服务器允许从服务器登录的用户名
mysql_password="123456" # 主服务器允许从服务器登录的密码
root_password="root"

# 主库列表
master_container=lrmp-mysql-master

# 从库列表
slave_containers=(lrmp-mysql-slave-1 )

#################### 函数定义 ####################
# 获取服务器的ip
docker-ip() {
    docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}


#################### 主服务器操作 ####################开始
# 在主服务器上添加数据库用户
#priv_stmt='GRANT REPLICATION SLAVE ON *.* TO "'$mysql_user'"@"%" IDENTIFIED BY "'$mysql_password'"; FLUSH PRIVILEGES;'

#docker exec $master_container sh -c "export MYSQL_PWD='$root_password'; mysql -u root -e '$priv_stmt'"

# 查看主服务器的状态
MS_STATUS=`docker exec $master_container sh -c 'export MYSQL_PWD='$root_password'; mysql -u root -e "SHOW MASTER STATUS"'`

# binlog文件名字,对应 File 字段,值如: mysql-bin.000004
CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
# binlog位置,对应 Position 字段,值如: 1429
CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`


#################### 从服务器操作 ####################开始
# 设置从服务器与主服务器互通命令
start_slave_stmt="RESET SLAVE;CHANGE MASTER TO 
		MASTER_HOST='$(docker-ip $master_container)',
		MASTER_USER='$mysql_user',
        MASTER_PASSWORD='$mysql_password',
        MASTER_LOG_FILE='$CURRENT_LOG',
        MASTER_LOG_POS=$CURRENT_POS;"
start_slave_cmd='export MYSQL_PWD='$root_password'; mysql -u root -e "'
start_slave_cmd+="$start_slave_stmt"
start_slave_cmd+='START SLAVE;"'


echo $start_slave_cmd
# 执行从服务器与主服务器互通
for slave in "${slave_containers[@]}";do
  echo $slave
  # 从服务器连接主互通
  docker exec $slave sh -c "$start_slave_cmd"
  # 查看从服务器得状态
  docker exec $slave sh -c "export MYSQL_PWD='$root_password'; mysql -u root -e 'SHOW SLAVE STATUS \G'"
done

echo -e "\033[42;34m finish success !!! \033[0m"

