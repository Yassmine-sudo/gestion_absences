FROM jenkins/jenkins:lts

USER root

# Installer les dépendances de base et Docker
RUN apt-get update && apt-get install -y \
    sudo curl git sshpass python3-full python3-venv \
    gnupg lsb-release ca-certificates apt-transport-https \
    software-properties-common docker.io \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Installer Docker Compose (version 1.29.2)
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Vérification version (bon pour logs)
RUN docker --version && docker-compose --version

# Créer un environnement virtuel Python pour Ansible
RUN python3 -m venv /opt/ansible-venv && \
    /opt/ansible-venv/bin/pip install --upgrade pip && \
    /opt/ansible-venv/bin/pip install ansible docker && \
    /opt/ansible-venv/bin/ansible-galaxy collection install community.docker || true

# Ajouter le venv Ansible au PATH
ENV PATH="/opt/ansible-venv/bin:$PATH"

# Ajouter l'utilisateur Jenkins au groupe docker
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins
