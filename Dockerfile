FROM centos:7

RUN yum update
RUN yum -y install wget
RUN yum -y install unzip
RUN yum -y install epel-release
RUN yum -y install nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.virtual.qa.conf /etc/nginx/conf.d/virtual-host.qa.conf

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm"
RUN yum -y localinstall jdk-8u161-linux-x64.rpm
RUN export JAVA_HOME=/usr/java/jdk1.8.0_161/jre
RUN sh -c "echo export JAVA_HOME=/usr/java/jdk1.8.0_161/jre >> /etc/environment"
RUN rm jdk-8u161-linux-x64.rpm

RUN yum -y install initscripts && yum clean all

RUN wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.zip -P /root/
RUN unzip /root/apache-tomcat-8.5.30.zip -d /root/
RUN mv /root/apache-tomcat-8.5.30 /root/qa-web-tomcat

RUN chmod +x /root/qa-web-tomcat/bin/catalina.sh
RUN chmod +x /root/qa-web-tomcat/bin/startup.sh

COPY server-qa.xml  /root/qa-web-tomcat/conf/server.xml

COPY tomcat-web /etc/init.d/tomcat-web

RUN chmod +x /etc/init.d/tomcat-web

RUN chkconfig tomcat-web on

COPY init.sh /usr/local/bin/init_server.sh

RUN mkdir /root/.modulusuno
COPY application-test.groovy /root/.modulusuno/

RUN rm -rf /root/qa-web-tomcat/webapps/*
ADD http://docker.war.deployments.s3.amazonaws.com/modulusuno/qa/web/ROOT.war /root/qa-web-tomcat/webapps/

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /root/qa-web-tomcat/logs/catalina.out

CMD ["sh", "/usr/local/bin/init_server.sh"]

EXPOSE 80
