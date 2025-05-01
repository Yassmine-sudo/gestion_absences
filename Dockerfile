FROM jenkins/jenkins:lts

USER root

# Installer les dépendances
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
    --no-install-recommends

# Ajouter la clé GPG officielle Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

# Ajouter le dépôt Docker
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list && apt-get update

# Installer Docker CLI + Compose Plugin
RUN apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Installer Ansible
RUN apt-get install -y ansible

# Installer la collection Docker Ansible
RUN ansible-galaxy collection install community.docker

# Nettoyage
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Ajouter Jenkins au groupe Docker (efficace uniquement si le conteneur est relancé avec le bon volume et groupe)
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins
