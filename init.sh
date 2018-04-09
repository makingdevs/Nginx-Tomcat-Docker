#! /bin/bash -e

echo "Ejecuntando script"
service nginx start
service tomcat-web start
service tomcat-api start
tail -F -n0 /etc/hosts
echo "Terminanod script"