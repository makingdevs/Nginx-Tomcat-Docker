FROM centos:7

RUN yum -y install wget
RUN yum -y install unzip

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm"
RUN yum -y localinstall jdk-8u161-linux-x64.rpm
RUN export JAVA_HOME=/usr/java/jdk1.8.0_161/jre
RUN sh -c "echo export JAVA_HOME=/usr/java/jdk1.8.0_161/jre >> /etc/environment"
RUN rm jdk-8u161-linux-x64.rpm

RUN yum -y install initscripts && yum clean all

RUN wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.zip -P /root/
RUN unzip /root/apache-tomcat-8.5.30.zip -d /root/
RUN mv /root/apache-tomcat-8.5.30 /root/tomcat

RUN chmod +x /root/tomcat/bin/catalina.sh
RUN chmod +x /root/tomcat/bin/startup.sh

COPY server.xml  /root/tomcat/conf/server.xml

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

CMD ["sh", "/usr/local/bin/init_server.sh"]

EXPOSE 8080
