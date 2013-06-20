#! /bin/bash
echo -e ""
echo -e "\e[1;31m  -  VirtualSkynet CentOS AutoInstall Script  -  \e[0m"
echo -e ""

echo -e "\e[1;31m  -  Disable Selinux Runtime  -  \e[0m"
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo -e "\e[1;31m  -  Installing Linux Tools  -  \e[0m"
yum -y install htop


echo -e "\e[1;31m  -  Installing Database Server  -  \e[0m"
rpm -ivh http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm
yum -y install postgresql92-server
service postgresql-9.2 initdb
service postgresql-9.2 start
chkconfig postgresql-9.2 on

echo -e "\e[1;31m  -  Setting Up Database Server  -  \e[0m"
rm -rf /var/lib/pgsql/9.2/data/postgresql.conf
rm -rf /var/lib/pgsql/9.2/data/pg_hba.conf
cp database/postgres/*  /var/lib/pgsql/9.2/data/


echo -e "\e[1;31m  -  Installing Java JDK  -  \e[0m"
rpm -ivh http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/7/jdk-7u21-linux-x64.rpm


echo -e "\e[1;31m  -  Installing VirtualSkynet Server  -  \e[0m"
wget http://apache.osuosl.org/tomee/tomee-1.5.2/apache-tomee-1.5.2-plus.tar.gz
tar xfz apache-tomee-*.tar.gz
rm -rf apache-tomee-*.tar.gz
mv apache-tomee-* virtualskynet
cd virtualskynet
rm -rf LICENSE  NOTICE  RELEASE-NOTES  RUNNING.txt webapps/* 
cd conf
rm -rf  *.original server.xml  tomee.xml  web.xml
cd ..
cd ..
mkdir virtualskynet/lib/ext
cp middleware/tomee/* virtualskynet/conf/
cp middleware/lib/*  virtualskynet/lib/ext/
mv virtualskynet /root
echo -e "\e[1;31m  -  Installing VirtualSkynet InitScripts  -  \e[0m"
mv init/centos/virtualskynet  /etc/init.d/
chmod 777 /etc/init.d/virtualskynet
service virtualskynet start
chkconfig virtualskynet on
mv virtualskynet /root


echo -e "\e[1;31m  -  VirtualSkynet Application Suite Install - Version 1.0  -  \e[0m"
echo -e "\e[1;31m  -  Installing Last Aplication Suite Version  -  \e[0m"
mv aplication/*.war  /root/virtualskynet/webapps


echo -e "\e[1;31m  -  Restarting Application Server  -  \e[0m"
service virtualskynet restart


echo -e "\033[33;31m   IMPORTANT!! DON'T FORGET SET YOUR IP ADDRESS IN /var/lib/pgsql/9.2/data/pg_hba.conf   \e[0m"
echo -e "\033[33;31m --- Aplication Install ... Done! ---"
