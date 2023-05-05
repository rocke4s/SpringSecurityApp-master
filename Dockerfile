 cd/o.
FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY target/SpringSecurityApp.war /app
COPY data/users.db /app
RUN wget -nv -P /tmp https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.74/bin/apache-tomcat-9.0.74.tar.gz
RUN tar -xzf /tmp/apache-tomcat-9.0.74.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-9.0.74 /opt/tomcat
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
COPY config/server.xml $CATALINA_HOME/conf
COPY config/tomcat-users.xml $CATALINA_HOME/conf
COPY config/context.xml $CATALINA_HOME/conf
COPY config/manager.xml $CATALINA_HOME/conf/Catalina/localhost
RUN rm -rf $CATALINA_HOME/webapps/ROOT*
COPY target/SpringSecurityApp.war $CATALINA_HOME/webapps/ROOT.war
RUN mv $CATALINA_HOME/webapps/ROOT.war $CATALINA_HOME/webapps/
WORKDIR /opt/tomcat/webapps/myapp
RUN mkdir /opt/tomcat/webapps/myapp/data
COPY src/main/webapp/WEB-INF/views/ /opt/tomcat/webapps/myapp/WEB-INF/jsp/
EXPOSE 80
CMD ["catalina.sh", "run"]