FROM jboss/base-jdk:7

### File Author / Maintainer
MAINTAINER "Robert Greathouse" "cyotee@gmail.com"

USER root

RUN mkdir -p /Users/robertgreathouse/Downloads/jboss-eap-6.4/standalone/log && \
    chown -R jboss:jboss /Users/robertgreathouse/Downloads/jboss-eap-6.4/standalone/log

USER jboss

### Install EAP 6.4.0
ADD artifacts/jboss-eap-6.4.4.zip /tmp/jboss-eap-6.4.4.zip
#ADD installs/jboss-eap-6.4.4-patch.zip /tmp/jboss-eap-6.4.4-patch.zip
#ADD installs/self-install-script-bpm-6.2-eap-6.4.4.xml /tmp/self-install-script-bpm-6.2-eap-6.4.4.xml
#ADD installs/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar /tmp/jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar
#ADD installs/patch.batch /tmp/patch.batch
ADD artifacts/jboss-bpmsuite-6.2.0.GA-deployable-eap6.x.zip /tmp/jboss-bpmsuite-6.2.0.GA-deployable-eap6.x.zip
ADD artifacts/repositories.zip /tmp/repositories.zip

### Set Environment
ENV JBOSS_HOME /opt/jboss/jboss-eap-6.4

#RUN unzip /tmp/jboss-eap-6.4.4.zip -d /opt/jboss && \
#    echo "Adding admin user." && \
#    $JBOSS_HOME/bin/add-user.sh admin admin123! --silent && \
#    echo "Setting bind address in $JBOSS_HOME/bin/standalone.conf" && \
#    echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf && \
#    echo "Starting Jboss to apply patch" && \
#    nohup $JBOSS_HOME/bin/standalone.sh > /dev/null && \
#    echo "Applying 6.4.4 patch to EAP" && \
#    $JBOSS_HOME/bin/jboss-cli.sh --connect --file=/tmp/patch.batch && \
#    echo "Installing jBPM." && \
#    java -jar jboss-bpmsuite-installer-6.2.0.BZ-1299002.jar self-install-script-bpm-6.2-eap-6.4.4.xml

RUN unzip -uo /tmp/jboss-eap-6.4.4.zip -d /opt/jboss && \
#    rm -f /tmp/jboss-eap-6.4.4.zip && \
    mv -vf /opt/jboss/jboss-eap-6.4.4 /opt/jboss/jboss-eap-6.4 && \
    echo "Adding JBoss admin user." && \
    $JBOSS_HOME/bin/add-user.sh admin jb0ssr@cks --silent && \
    echo "Adding JBPM admin user." && \
    $JBOSS_HOME/bin/add-user.sh -a jbpmadmin jb0ssr@cks --silent && \
    echo "Setting bind address in $JBOSS_HOME/bin/standalone.conf" && \
    echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf && \
    echo "Installing jBPM." && \
    unzip -uo /tmp/jboss-bpmsuite-6.2.0.GA-deployable-eap6.x.zip -d /opt/jboss && \
#    rm -f /tmp/jboss-bpmsuite-6.2.0.GA-deployable-eap6.x.zip && \
    echo "Applying JBPM critical patch for missing files." && \
    unzip -uo /tmp/repositories.zip -d /opt/jboss/
#    rm -f /tmp/repositories.zip

### Open Ports
EXPOSE 8080 9990 9999

### Start EAP
CMD $JBOSS_HOME/bin/standalone.sh