FROM jenkins/jenkins

USER root

RUN mkdir -p /tmp/download && \
    curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.13.1.tgz | tar -xz -C /tmp/download && \
    rm -rf /tmp/download/docker/dockerd && \
    mv /tmp/download/docker/docker* /usr/local/bin/ && \
    rm -rf /tmp/download && \
    groupadd -g 999 docker && \
    usermod -aG docker jenkins

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

USER jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

COPY kubeconfig.yaml /etc/kubernetes/kubeconfig
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml
COPY jobs/seedjob.xml /usr/share/jenkins/ref/jobs/seed/config.xml
COPY jobs/dsl /usr/share/jenkins/ref/dsl

ENTRYPOINT docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} && /usr/bin/tini -- /usr/local/bin/jenkins.sh
