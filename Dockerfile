FROM jenkins/jenkins:lts

USER root

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    gnupg \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    --no-install-recommends

# Ajouter la clé GPG officielle de Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

# Ajouter le dépôt Docker compatible avec Debian
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker CLI et plugins
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Télécharger docker-compose (optionnel si tu veux une version spécifique)
RUN curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Créer le groupe docker si inexistant, et y ajouter jenkins
RUN groupadd -f docker && usermod -aG docker jenkins

# Donner accès au socket à Jenkins via son groupe
RUN chown root:docker /var/run/docker.sock && chmod 660 /var/run/docker.sock

# Nettoyer
RUN apt-get clean

# Revenir à l'utilisateur jenkins
USER jenkins
