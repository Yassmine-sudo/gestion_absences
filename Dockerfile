# Utiliser une image de base officielle Ubuntu
FROM ubuntu:20.04

# Installer les dépendances nécessaires : Docker, Ansible, Python, etc.
RUN apt-get update && apt-get install -y \
    python3-pip \
    sshpass \
    git \
    curl \
    sudo \
    && pip3 install ansible \
    && rm -rf /var/lib/apt/lists/*

# Créer le groupe docker et ajouter l'utilisateur Jenkins
RUN groupadd -g 999 docker && usermod -aG docker jenkins

# Installer Docker et Docker-compose
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Définir le répertoire de travail par défaut
WORKDIR /workspace

# Entrée par défaut (optionnel)
ENTRYPOINT ["bash"]
