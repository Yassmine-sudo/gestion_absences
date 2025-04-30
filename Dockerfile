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
    sshpass \
    git \
    --no-install-recommends

# Ajouter la clé GPG officielle de Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

# Ajouter le dépôt Docker compatible avec Debian
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker CLI et plugins
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Installer Ansible
RUN pip3 install --no-cache-dir --break-system-packages ansible

# Ajouter l'utilisateur jenkins au groupe docker (il existe déjà)
RUN groupadd -f docker && usermod -aG docker jenkins

# Nettoyer
RUN apt-get clean

# Revenir à l'utilisateur Jenkins
USER jenkins
