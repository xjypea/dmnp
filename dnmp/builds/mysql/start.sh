#!/bin/sh

cp /etc/mysql/mysql.conf.d/source/* /etc/mysql/mysql.conf.d/

/entrypoint.sh mysqld