FROM jboss/base-jdk:7

### File Author / Maintainer
MAINTAINER "Robert Greathouse" "robert@opensourcearchitect.co"

USER jboss

### Install EAP 6.4.0
ADD installs/jboss-eap-6.4.0.zip /tmp/jboss-eap-6.4.0.zip
ADD installs/jboss-eap-6.4.4-patch.zip /tmp/jboss-eap-6.4.4-patch.zip
ADD installs/self-install-script-bpm-6.2-eap-6.4.4.xml /tmp/self-install-script-bpm-6.2-eap-6.4.4.xml
ADD installs/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar /tmp/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar

### Set Environment
ENV JBOSS_HOME /opt/jboss/jboss-eap-6.4

RUN unzip /tmp/jboss-eap-6.4.0.zip && \
    $JBOSS_HOME/bin/add-user.sh admin 0p3ns0urc3! --silent && \
    RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf && \
    nohup $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml > /dev/null && \
    /opt/jboss/jboss-eap-6.4/jboss-cli.sh --file=/tmp/self-install-script-bpm-6.2-eap-6.4.4.xml && \
    java -jar jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar self-install-script-bpm-6.2-eap-6.4.4.xml

### Open Ports
EXPOSE 8080 9990 9999

### Start EAP
CMD $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml