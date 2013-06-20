#! /bin/bash
export DEBIAN_FRONTEND=noninteractive

echo -e ""
echo -e "\e[1;31m  -  VirtualSkynet Debian AutoInstall Script  -  \e[0m"
echo -e ""

echo -e "\e[1;31m  -  Updating System  -  \e[0m"
apt-get -y update
apt-get -y upgrade

echo -e "\e[1;31m  -  Installing Asterisk  -  \e[0m"
apt-get -y install asterisk

echo -e "\e[1;31m  -  Installing Mysql  -  \e[0m"
apt-get -y install mysql-server mysql-client



echo -e "\e[1;31m  -  Setting Up ODBC Realtime  -  \e[0m"
echo "[mysql]" >> /etc/odbc.ini
echo "Description = MySQL Asterisk database" >> /etc/odbc.ini
echo "Trace = Off" >> /etc/odbc.ini
echo "TraceFile = stderr" >> /etc/odbc.ini
echo "Driver = MySQL" >> /etc/odbc.ini
echo "SERVER = localhost" >> /etc/odbc.ini
echo "USER = root" >> /etc/odbc.ini
echo "PASSWORD = ${PASSWORD}" >> /etc/odbc.ini
echo "PORT = 3306" >> /etc/odbc.ini
echo "DATABASE = pbx" >> /etc/odbc.ini


echo -e "\e[1;31m  -  Installing VSN Asterisk Packages  -  \e[0m"
yum -y install  make  gcc  gcc-c++  openssl-devel libtermcap-devel libxml2-devel sqlite-devel htop
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum -y install sox mpg123 lame

echo -e "\e[1;31m  -  Installing Asterisk Core  -  \e[0m"
wget ${ASTERISK}
tar xfz asterisk*
rm -rf *.tar.gz
cd asterisk*
./configure
make && make install && make config
service asterisk start
chkconfig asterisk on
cd ..
rm -rf asterisk*

echo -e "\e[1;31m  -  Setting Asterisk Configuration  -  \e[0m"
cp -rf conf/asterisk/* /etc/asterisk/

echo -e "\e[1;31m  -  Setting Up Database Server  -  \e[0m"
service mysqld start
chkconfig mysqld on
echo "bind-address=0.0.0.0" >> /etc/my.cnf
echo "lower_case_table_names = 1" >> /etc/my.cnf
mysql -e " DROP DATABASE TEST "
mysql -e " CREATE DATABASE security "
mysql -e " CREATE DATABASE pbx "
mysql -e " CREATE DATABASE billing "
mysql -e " CREATE DATABASE callcenter "
mysql -e " GRANT ALL ON *.*  TO 'root'@'%'  IDENTIFIED BY '${PASSWORD}' "
mysql -e " GRANT ALL ON *.*  TO 'root'@'localhost'  IDENTIFIED BY '${PASSWORD}' "

#------------------------------------------------------------------------------------------

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
cp conf/tomee/*.xml virtualskynet/conf/
cp conf/tomee/lib/*  virtualskynet/lib/
mv virtualskynet /root

echo -e "\e[1;31m  -  Installing VirtualSkynet InitScripts  -  \e[0m"
cp conf/tomee/service-virtualskynet  /etc/init.d/
chmod 777 /etc/init.d/virtualskynet
service virtualskynet start
chkconfig virtualskynet on

echo -e "\e[1;31m  -  VirtualSkynet Application Suite Install - Version 1.0  -  \e[0m"
echo -e "\e[1;31m  -  Installing Last Aplication Suite Version  -  \e[0m"
cp aplication/*.war  /root/virtualskynet/webapps/

echo -e "\e[1;31m  -  IMPORTANT!! DON'T FORGET PUT YOUR PUBLIC IP ADDRESS IN SIP.CONF (externip)  -  \e[0m"
echo -e "\033[33;31m --- Aplication Install ... Done! ---"
init 6
