# Utiliser l'image officielle Jenkins LTS comme base
FROM jenkins/jenkins:lts

# Passer en mode utilisateur root pour installer les dépendances
USER root

# Installer SonarScanner
RUN apt-get update && apt-get install -y curl unzip && \
    curl -o /tmp/sonar-scanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip && \
    unzip /tmp/sonar-scanner.zip -d /opt/ && \
    ln -s /opt/sonar-scanner-4.8.0.2856-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm /tmp/sonar-scanner.zip && \
    apt-get clean

# Passer à l'utilisateur Jenkins
USER jenkins
