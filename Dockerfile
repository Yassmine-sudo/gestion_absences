# Utiliser l'image officielle Jenkins LTS comme base
FROM jenkins/jenkins:lts

# Exécuter la mise à jour et l'installation des outils de base
USER root
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
    ansible \
    sudo \
    --no-install-recommends

# Ajouter le dépôt officiel de Docker pour installer Docker et Docker Compose
RUN curl -fsSL https://get.docker.com | sh \
    && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose \
    --no-install-recommends

# Ajouter l'utilisateur Jenkins au groupe Docker pour lui permettre d'exécuter Docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Pour utiliser Docker à l'intérieur de Jenkins, vous devez vous assurer que Docker est bien configuré.
# Installer les plugins nécessaires à Jenkins
RUN jenkins-plugin-cli --plugins "docker-workflow"

# Exposer les ports utilisés par Jenkins (par défaut)
EXPOSE 8080
EXPOSE 50000

# Démarrer Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
