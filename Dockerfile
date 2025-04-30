# Utiliser l'image officielle de Jenkins LTS
FROM jenkins/jenkins:lts

# Passer en mode root pour installer Docker et autres dépendances
USER root

# Mettre à jour les packages et installer les dépendances pour curl et Docker
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    gnupg2 \
    --no-install-recommends

# Ajouter le dépôt Docker officiel pour installer Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Installer Docker
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Télécharger Docker Compose
RUN curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

# Rendre Docker Compose exécutable
RUN chmod +x /usr/local/bin/docker-compose

# Créer un lien symbolique pour docker-compose
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Créer un groupe docker et ajouter l'utilisateur Jenkins au groupe Docker
RUN groupadd docker && usermod -aG docker jenkins

# Nettoyer le cache apt
RUN apt-get clean

# Passer de nouveau à l'utilisateur Jenkins pour les étapes suivantes
USER jenkins
