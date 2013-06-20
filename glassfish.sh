asadmin enable-secure-admin
asadmin restart-domain

# cd /usr/local/glassfishv3/glassfish/bin
# ./asadmin --host 192.168.209.148 --port 4848 change-admin-password
Enter admin user name [default: admin]>
Enter admin password> //admin password is blank so just press enter
Enter new admin password>
Enter new admin password again>
Command change-admin-password executed successfully.



#!/bin/bash
# chkconfig: 2345 95 20
# description: Script to Start Stop Restart GlassFish
JAVA_HOME=/usr/java/jdk1.7.0_21
export JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH
export PATH
GLASSFISH_HOME=/usr/local/glassfish3/glassfish
case $1 in
start)
/bin/su glassfish $GLASSFISH_HOME/bin/asadmin start-domain domain1
;;
stop)
/bin/su glassfish $GLASSFISH_HOME/bin/asadmin stop-domain domain1
;;
restart)
/bin/su glassfish $GLASSFISH_HOME/bin/asadmin stop-domain domain1
/bin/su glassfish $GLASSFISH_HOME/bin/asadmin start-domain domain1
;;
esac
exit 0