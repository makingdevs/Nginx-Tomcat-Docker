#! /bin/bash -e

echo "Ejecuntando script"
service nginx start
service tomcat-web start
tail -F -n0 /etc/hosts
echo "Terminanod script"