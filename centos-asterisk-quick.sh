#! /bin/bash
PASSWORD=p4ssw0rd

echo -e ""
echo -e "\e[1;31m  -  VirtualSkynet CentOS AutoInstall Script  -  \e[0m"
echo -e ""

echo -e "\e[1;31m  -  Disable Selinux Runtime  -  \e[0m"
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo -e "\e[1;31m  -  Installing Linux Tools  -  \e[0m"
yum -y install htop

echo -e "\e[1;31m  -  Installing Linux MySQL ODBC Support  -  \e[0m"
yum -y install unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel mysql-connector-odbc mysql-devel postgresql-odbc postgresql postgresql-devel

echo -e "\e[1;31m  -  Installing VSN Asterisk Realtime Packages  -  \e[0m"
yum install asterisk asterisk-odbc asterisk-sounds-core-en-sln16 asterisk-voicemail-odbc
chckconfig asterisk on

echo -e "\e[1;31m  -  Setting Up ODBC Realtime  -  \e[0m"
echo "[mysql]" >> /etc/odbc.ini
echo "Description = MySQL Asterisk database" >> /etc/odbc.ini
echo "Trace = Off" >> /etc/odbc.ini
echo "TraceFile = stderr" >> /etc/odbc.ini
echo "Driver = MySQL" >> /etc/odbc.ini
echo "SERVER = db.virtualskynet.com" >> /etc/odbc.ini
echo "USER = root" >> /etc/odbc.ini
echo "PASSWORD = ${PASSWORD}" >> /etc/odbc.ini
echo "PORT = 3306" >> /etc/odbc.ini
echo "DATABASE = pbx" >> /etc/odbc.ini

echo -e "\e[1;31m  -  Install Additional Repos  -  \e[0m"
rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum -y install  mpg123 lame


echo -e "\e[1;31m  -  Setting Asterisk Configuration  -  \e[0m"
mv /etc/asterisk/asterisk.conf  /etc/asterisk/asterisk.conf.tmp
rm -rf /etc/asterisk/*.conf
rm -rf /etc/asterisk/*.adsi
rm -rf /etc/asterisk/*.ael
mv /etc/asterisk/asterisk.conf.tmp  /etc/asterisk/asterisk.conf
cp -rf conf/asterisk/* /etc/asterisk/


echo -e "\e[1;31m  -  IMPORTANT!! DON'T FORGET PUT YOUR PUBLIC IP ADDRESS IN SIP.CONF (externip)  -  \e[0m"
echo -e "\033[33;31m --- Asterisk Install ... Done! ---"
init 6
