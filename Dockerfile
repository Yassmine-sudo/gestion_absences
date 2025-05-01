# Utiliser l'image officielle Jenkins LTS comme base
FROM jenkins/jenkins:lts

USER root

# Mise à jour et installation des outils de base
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    gnupg \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    python3-pip \
    sshpass \
    git \
    jq \
    ansible \
    --no-install-recommends

# Installer Docker CE (client + daemon)
RUN curl -fsSL https://get.docker.com | sh

# Installer Docker Compose (version stable et connue)
ENV DOCKER_COMPOSE_VERSION=1.29.2

# Remplace ta commande actuelle par celle-ci
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose \
 && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


# Ajouter l'utilisateur Jenkins au groupe Docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Exposer les ports Jenkins
EXPOSE 8080
EXPOSE 50000

# Démarrer Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
