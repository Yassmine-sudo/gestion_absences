FROM jenkins/jenkins:lts

USER root

# Installer les dépendances de base
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    gnupg \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    python3-pip \
    sshpass \   # Assure-toi que sshpass est installé via apt
    git \
    --no-install-recommends

# Ajouter la clé GPG officielle de Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

# Ajouter le dépôt Docker compatible avec Debian
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update

# Installer Docker CLI et plugins
RUN apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Installer Ansible via apt (version stable, adaptée aux environnements Docker)
RUN apt-get install -y ansible

# Installer la collection Docker pour Ansible
RUN ansible-galaxy collection install community.docker

# Ajouter l'utilisateur Jenkins au groupe Docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Nettoyer pour réduire la taille de l'image
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins
