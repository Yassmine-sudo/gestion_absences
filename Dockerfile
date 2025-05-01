# Utilisation de l'image Jenkins officielle LTS
FROM jenkins/jenkins:lts

# Devenir root pour installer des paquets
USER root

# Mise à jour de l'image et installation des dépendances
RUN apt-get update && \
    apt-get install -y \
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
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    docker-buildx-plugin \
    --no-install-recommends

# Nettoyage pour réduire la taille de l'image
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Ajouter l'utilisateur Jenkins au groupe Docker pour permettre l'utilisation de Docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Définir le répertoire de travail
WORKDIR /var/jenkins_home

# Entrée par défaut du conteneur
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
