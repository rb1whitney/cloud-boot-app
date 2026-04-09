FROM jenkins/jenkins:lts

# Setup Jenkins Mirror and Port
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org
EXPOSE 8080
USER root

# Install All Required Plugins
# Note: install-plugins.sh is deprecated in newer Jenkins images, 
# but keeping original flow for minimal impact unless build fails.
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

# Install Required Software (Modernized to Java 21)
RUN apt-get update && apt-get install -y git jq openjdk-21-jre-headless maven
