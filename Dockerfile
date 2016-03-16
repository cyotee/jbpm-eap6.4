FROM jboss/base-jdk:7

### File Author / Maintainer
MAINTAINER "Robert Greathouse" "robert@opensourcearchitect.co"

USER jboss

### Install EAP 6.4.0
ADD installs/jboss-eap-6.4.0.zip /tmp/jboss-eap-6.4.0.zip
ADD installs/jboss-eap-6.4.4-patch.zip /tmp/jboss-eap-6.4.4-patch.zip
ADD installs/self-install-script-bpm-6.2-eap-6.4.4.xml /tmp/self-install-script-bpm-6.2-eap-6.4.4.xml
ADD installs/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar /tmp/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar
ADD installs/patch.batch /tmp/patch.batch

### Set Environment
ENV JBOSS_HOME /opt/jboss/jboss-eap-6.4

RUN unzip /tmp/jboss-eap-6.4.0.zip -d /opt/jboss && \
    echo "Adding admin user." && \
    $JBOSS_HOME/bin/add-user.sh admin admin123! --silent && \
    echo "Setting bind address in $JBOSS_HOME/bin/standalone.conf" && \
    echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf && \
    echo "Starting Jboss to apply patch" && \
    nohup $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml > /dev/null && \
    echo "
    $JBOSS_HOME/bin/jboss-cli.sh --file=/tmp/patch.batch && \
    java -jar jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar self-install-script-bpm-6.2-eap-6.4.4.xml

### Open Ports
EXPOSE 8080 9990 9999

### Start EAP
CMD $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml