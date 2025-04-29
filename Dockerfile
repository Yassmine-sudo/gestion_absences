FROM jenkins/jenkins:lts

USER root

# Installer les dépendances pour ajouter les clés et le dépôt Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release --no-install-recommends

# Ajouter la clé GPG de Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg

# Ajouter le dépôt Docker à la liste des sources
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Mettre à jour les listes de paquets après avoir ajouté le dépôt Docker
RUN apt-get update

# Installer Docker Engine, la CLI et le plugin Docker Compose
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin --no-install-recommends

# Ajouter l'utilisateur jenkins au groupe docker
RUN usermod -aG docker jenkins

# Nettoyer le cache d'apt
RUN apt-get clean

USER jenkins