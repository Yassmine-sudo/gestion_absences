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
    ansible \
    --no-install-recommends

# Installation de Docker
RUN curl -fsSL https://get.docker.com | sh \
    && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    --no-install-recommends

# Installer Docker Compose (version la plus récente)
RUN curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Ajouter l'utilisateur Jenkins au groupe Docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Exposer les ports Jenkins
EXPOSE 8080
EXPOSE 50000

# Démarrer Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
