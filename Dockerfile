FROM jenkins/jenkins:lts

USER root

# Installer les dépendances pour curl
RUN apt-get update && apt-get install -y curl --no-install-recommends

# Télécharger la dernière version de docker-compose depuis GitHub Releases
RUN curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

# Rendre l'exécutable
RUN chmod +x /usr/local/bin/docker-compose

# Créer un lien symbolique pour que 'docker compose' fonctionne comme sous-commande de 'docker' (si nécessaire)
RUN ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Ajouter l'utilisateur jenkins au groupe docker
RUN usermod -aG docker jenkins

# Nettoyer le cache d'apt
RUN apt-get clean

USER jenkins