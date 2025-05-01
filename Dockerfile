FROM jenkins/jenkins:lts

USER root

# Installer les dépendances de base
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    sshpass \
    python3-full \
    python3-venv \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    --no-install-recommends

# Créer un environnement virtuel Python pour Ansible
RUN python3 -m venv /opt/ansible-venv && \
    /opt/ansible-venv/bin/pip install --upgrade pip && \
    /opt/ansible-venv/bin/pip install ansible

# Ajouter le venv au PATH pour qu'Ansible soit utilisable globalement
ENV PATH="/opt/ansible-venv/bin:$PATH"

# Ajouter la clé Docker et le dépôt Docker pour Debian
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Installer Docker Compose manuellement (optionnel)
RUN curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
    -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Ajouter Jenkins au groupe docker
RUN groupadd -f docker && usermod -aG docker jenkins

# Nettoyage
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Revenir à l'utilisateur Jenkins
USER jenkins
