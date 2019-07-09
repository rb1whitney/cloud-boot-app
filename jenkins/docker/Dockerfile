FROM jenkins/jenkins:lts

# Setup Jenkins Mirror and Port
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org
EXPOSE 8080
USER root

# Install All Required Plugins
RUN /usr/local/bin/install-plugins.sh \
    antisamy-markup-formatter \
    build-pipeline-plugin \
    build-timeout \
    credentials-binding \
    email-ext \
    git \
    git-client \
    github-branch-source \
    gradle \
    jobgenerator \
    ldap \
    mailer \
    performance \
    pipeline-github-lib \
    pipeline-stage-view \
    ssh-slaves \
    timestamper \
    workflow-aggregator \
    ws-cleanup

# Install Required Software
RUN apt-get update && apt-get install -y git jq openjdk-8-jre-headless maven