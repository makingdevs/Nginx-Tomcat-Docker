#! /bin/bash -e

echo "Ejecuntando script"
service tomcat start
tail -F -n0 /etc/hosts
echo "Terminanod script"