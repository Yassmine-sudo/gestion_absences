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

# Installer Docker CLI et plugins
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Installer Ansible et la collection Docker
RUN pip3 install --no-cache-dir ansible && \
    ansible-galaxy collection install community.docker

# Ajouter Jenkins au groupe Docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Nettoyage
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins
