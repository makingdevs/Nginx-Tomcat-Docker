#! /bin/bash -e

echo "Ejecuntando script"
service tomcat-web start
nginx
tail -F -n0 /etc/hosts
echo "Terminanod script"