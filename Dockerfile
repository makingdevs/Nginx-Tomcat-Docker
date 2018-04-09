FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install unzip
RUN apt-get -y install nginx

#VOLUME ["/root/.jenkins"]

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.virtual.qa.conf /etc/nginx/conf.d/virtual-host.qa.conf
COPY nginx.virtual.stage.conf /etc/nginx/conf.d/virtual-host.stage.conf

RUN apt-get -y install default-jdk

RUN wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.zip -P /root/
RUN unzip /root/apache-tomcat-8.5.29.zip -d /root/
RUN mv /root/apache-tomcat-8.5.29 /root/qa-tomcat

RUN chmod +x /root/qa-tomcat/bin/catalina.sh
RUN chmod +x /root/qa-tomcat/bin/startup.sh

RUN cp -R /root/qa-tomcat /root/stage-tomcat

COPY server-qa.xml  /root/qa-tomcat/conf/server.xml
COPY server-stage.xml  /root/stage-tomcat/conf/server.xml

COPY tomcat-qa /etc/init.d/tomcat-qa
COPY tomcat-stage /etc/init.d/tomcat-stage

RUN chmod +x /etc/init.d/tomcat-qa
RUN chmod +x /etc/init.d/tomcat-stage

RUN update-rc.d tomcat-qa defaults
RUN update-rc.d tomcat-stage defaults

COPY init.sh /usr/local/bin/init_server.sh

RUN rm -rf /root/qa-tomcat/webapps/* 
COPY ROOT.war /root/qa-tomcat/webapps/

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /root/qa-tomcat/logs/catalina.out

CMD ["sh", "/usr/local/bin/init_server.sh"]

EXPOSE 80 8080
