#! /bin/bash -e

echo "Ejecuntando script"
service nginx start
service tomcat-qa start
service tomcat-stage start
tail -F -n0 /etc/hosts
echo "Terminanod script"