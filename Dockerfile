FROM jenkins/jenkins:lts

USER root

# Installer les dépendances, Docker, Python et Ansible
RUN apt-get update && apt-get install -y \
    sudo curl git sshpass python3-full python3-venv \
    gnupg lsb-release ca-certificates apt-transport-https \
    software-properties-common docker.io \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Créer un environnement virtuel Python et installer Ansible
RUN python3 -m venv /opt/ansible-venv && \
    /opt/ansible-venv/bin/p
