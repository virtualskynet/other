
URL=http://ufpr.dl.sourceforge.net/project/elastix/Elastix%20PBX%20Appliance%20Software/2.4.0/Elastix-2.4.0-Stable-x86_64-bin-04feb2013.iso
ISO=/root/Elastix-2.4.0-Stable-x86_64-bin-04feb2013.iso

echo -e "\e[1;31m  -  Disable Selinux Runtime  -  \e[0m"
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

yum -y update
yum -y install vim-enhanced

wget ${URL}
mkdir /mnt/iso
mount -o loop ${SKYNET} /mnt/iso
cd /mnt/iso

touch /etc/yum.repos.d/elastix.repo
echo "[elastix]" >> /etc/yum.repos.d/elastix.repo
echo "name=Elastix RPM Repo CD" >> /etc/yum.repos.d/elastix.repo
echo "baseurl=file:///mnt/iso/" >> /etc/yum.repos.d/elastix.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/elastix.repo
echo "enabled=1" >> /etc/yum.repos.d/elastix.repo

chkconfig dahdi off 
chkconfig wanrouter off 
chkconfig iptables off
chkconfig ip6tables off
chkconfig elastix-portknock off
chkconfig mysqld on
chkconfig asterisk on
chkconfig httpd on

/usr/bin/sqlite3 /var/www/db/acl.db "UPDATE acl_user SET md5_password = '`echo -n p4ssw0rd|md5sum|cut -d ' ' -f 1`' WHERE name = 'admin'"

# Audit Log Problem
cd /var/log/elastix
touch audit.log
chown asterisk:asterisk audit.log

#Dahdi Error
mv chan_dahdi.conf chan_dahdi.conf.bkp

#FirstBoot
/usr/bin/elastix-admin-passwords --init

#Manager
bindaddr = 127.0.0.1
cd /var/lib/asterisk/bin
php retrieve_conf 


#Remove HTTPS
<Directory "/var/www/html">
    # Redirect administration interface to https
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
</Directory>

[elastix-extras]
name=Extras RPM Repository for Elastix  
mirrorlist=http://mirror.elastix.org/?release=2&arch=$basearch&repo=extras
#baseurl=http://repo.elastix.org/elastix/2/extras/$basearch/
gpgcheck=1
enabled=1
gpgkey=http://repo.elastix.org/elastix/RPM-GPG-KEY-Elastix

yum -y install elastix-callcenter-2*
