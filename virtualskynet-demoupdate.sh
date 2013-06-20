#! /bin/bash

echo -e "\e[1;31m  -  VirtualSkynet Application Demo Update - Version 1.0  -  \e[0m"


echo -e "\e[1;31m  -  Installing Last Aplication Suite Version  -  \e[0m"
rm -rf /root/webapps/virtualskynet*
wget https://raw.github.com/virtualskynet/install/master/virtualskynet/code/service/virtualskynet.war
mv virtualskynet.war  /root/virtualskynet/webapps/


echo -e "\e[1;31m  -  Starting Database Server  -  \e[0m"
service postgresql-9.2 restart
dropdb virtualskynet  -U postgres


echo -e "\e[1;31m  -  Installing Last Database Schema  -  \e[0m"
wget https://raw.github.com/virtualskynet/install/master/virtualskynet/code/db/virtualskynet.sql
/usr/pgsql-9.2/bin/pg_restore  -U postgres  -C -c -d postgres  virtualskynet.sql
rm -rf virtualskynet.sql

echo -e "\e[1;31m  -  Restarting Application Server  -  \e[0m"
service virtualskynet start

sleep 2s  
         
echo -e "\033[33;31m --- Last Aplication Install ... Done! ---"