FROM jenkins/jenkins:lts

USER root

# Installer les dépendances de base
RUN apt-get update && apt-get install -y \
    sudo curl git sshpass python3-full python3-venv \
    gnupg lsb-release ca-certificates apt-transport-https \
    software-properties-common docker.io \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Créer un environnement virtuel Python et installer Ansible
RUN python3 -m venv /opt/ansible-venv && \
    /opt/ansible-venv/bin/pip install --upgrade pip && \
    /opt/ansible-venv/bin/pip install ansible docker && \
    /opt/ansible-venv/bin/ansible-galaxy collection install community.docker

# Ajouter le venv au PATH
ENV PATH="/opt/ansible-venv/bin:$PATH"

# Ajouter Jenkins au groupe docker
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins
