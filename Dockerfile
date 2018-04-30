FROM centos:7

RUN yum -y install wget
RUN yum -y install unzip

RUN wget http://docker.war.deployments.s3.amazonaws.com/third-party/jdk/jdk-8u171-linux-x64.rpm
RUN yum -y localinstall jdk-8u171-linux-x64.rpm
RUN export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64/jre
RUN sh -c "echo export JAVA_HOME=/usr/java/jdk1.8.0_171-amd64/jre >> /etc/environment"
RUN rm jdk-8u171-linux-x64.rpm

RUN yum -y install initscripts && yum clean all

RUN wget http://docker.war.deployments.s3.amazonaws.com/third-party/tomcat8/apache-tomcat-8.5.30.zip -P /root/
RUN unzip /root/apache-tomcat-8.5.30.zip -d /root/
RUN mv /root/apache-tomcat-8.5.30 /root/tomcat

RUN chmod +x /root/tomcat/bin/catalina.sh
RUN chmod +x /root/tomcat/bin/startup.sh

COPY server.xml  /root/tomcat/conf/server.xml
COPY setenv.sh  /root/tomcat/bin/setenv.sh
RUN chmod +x /root/tomcat/bin/setenv.sh

COPY tomcat /etc/init.d/tomcat

RUN chmod +x /etc/init.d/tomcat

RUN chkconfig tomcat on

COPY init.sh /usr/local/bin/init_server.sh

ARG FILE_NAME_CONFIGURATION
ARG PATH_NAME_CONFIGURATION
RUN mkdir $PATH_NAME_CONFIGURATION
COPY $FILE_NAME_CONFIGURATION $PATH_NAME_CONFIGURATION

RUN rm -rf /root/tomcat/webapps/*
ARG URL_WAR
ADD $URL_WAR /root/tomcat/webapps/

RUN ln -sf /dev/stdout /root/tomcat/logs/catalina.out

ARG FILENAME_LOG
RUN touch /root/tomcat/logs/$FILENAME_LOG
RUN ln -sf /dev/stdout /root/tomcat/logs/$FILENAME_LOG

RUN mkdir /root/nginxConf/

CMD ["sh", "/usr/local/bin/init_server.sh"]

EXPOSE 8080
