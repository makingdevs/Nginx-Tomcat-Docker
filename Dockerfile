FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install unzip
RUN apt-get -y install nginx

#VOLUME ["/root/.jenkins"]

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.virtual.qa.conf /etc/nginx/conf.d/virtual-host.qa.conf
COPY nginx.virtual.stage.conf /etc/nginx/conf.d/virtual-host.stage.conf

#RUN apt-get -y install default-jdk
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections &&   apt-get update &&   apt-get install -y software-properties-common &&  add-apt-repository -y ppa:webupd8team/java &&   apt-get update &&   apt-get install -y oracle-java8-installer  &&   rm -rf /var/lib/apt/lists/* &&   rm -rf /var/cache/oracle-jdk8-installer
RUN apt-get -y install oracle-java8-installer
RUN apt-get -y install oracle-java8-set-default

RUN wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.zip -P /root/
RUN unzip /root/apache-tomcat-8.5.30.zip -d /root/
RUN mv /root/apache-tomcat-8.5.30 /root/qa-web-tomcat

RUN chmod +x /root/qa-web-tomcat/bin/catalina.sh
RUN chmod +x /root/qa-web-tomcat/bin/startup.sh

RUN cp -R /root/qa-web-tomcat /root/qa-api-tomcat

COPY server-qa.xml  /root/qa-web-tomcat/conf/server.xml
COPY server-stage.xml  /root/qa-api-tomcat/conf/server.xml

COPY tomcat-web /etc/init.d/tomcat-web
COPY tomcat-api /etc/init.d/tomcat-api

RUN chmod +x /etc/init.d/tomcat-web
RUN chmod +x /etc/init.d/tomcat-api

RUN update-rc.d tomcat-web defaults
RUN update-rc.d tomcat-api defaults

COPY init.sh /usr/local/bin/init_server.sh

RUN mkdir /root/.modulusuno
COPY application-test.groovy /root/.modulusuno/
COPY application-api-test.groovy /root/.modulusuno/

RUN rm -rf /root/qa-web-tomcat/webapps/*
ADD http://docker.war.deployments.s3.amazonaws.com/modulusuno/qa/web/ROOT.war /root/qa-web-tomcat/webapps/

RUN rm -rf /root/qa-api-tomcat/webapps/*
#ADD http://docker.war.deployments.s3.amazonaws.com/modulusuno/qa/api/ROOT.war /root/qa-api-tomcat/webapps/
COPY ROOT.war /root/qa-api-tomcat/webapps/

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /root/qa-web-tomcat/logs/catalina.out
RUN ln -sf /dev/stdout /root/qa-api-tomcat/logs/catalina.out

CMD ["sh", "/usr/local/bin/init_server.sh"]

EXPOSE 80 8080
