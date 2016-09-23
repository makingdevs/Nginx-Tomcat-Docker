FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install unzip
RUN apt-get -y install nginx

#VOLUME ["/root/.jenkins"]

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.virtual.conf /etc/nginx/conf.d/virtual-host.conf

RUN apt-get -y install default-jdk

RUN wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.zip -P /root/
RUN unzip /root/apache-tomcat-8.5.5.zip -d /root/
RUN mv /root/apache-tomcat-8.5.5 /root/qa-tomcat

RUN chmod +x /root/qa-tomcat/bin/catalina.sh
RUN chmod +x /root/qa-tomcat/bin/startup.sh

COPY tomcat /etc/init.d/
RUN chmod +x /etc/init.d/tomcat
RUN update-rc.d tomcat defaults

COPY init.sh /usr/local/bin/init_server.sh
#COPY logging.properties /logging.properties

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["sh", "/usr/local/bin/init_server.sh"]

EXPOSE 80 8080