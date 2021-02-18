<?php

// phpinfo();

const DSN = "mysql:host=10.10.10.1:3306;dbname=test";
const USER_NAME = "root";
const PASSWORD = "root";

try{
    $conn = new PDO(DSN, USER_NAME, PASSWORD);

    echo "连接成功";
} catch (PDOException $e){
    echo $e->getMessage();
} finally {
    $conn = null;
    echo "关闭数据库连接";
}

