pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-app-with-ansible"
        DEPOLOY_DIR = "${WORKSPACE}/deploiement" // Répertoire local pour le déploiement
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                checkout scm
                script {
                    echo "Reset du dépôt sur origin/master"
                    sh 'git fetch --all'
                    sh 'git reset --hard origin/master'
                }
            }
        }

        stage('Vérification Docker') {
            steps {
                script {
                    echo "✅ Vérification Docker et Docker Compose"
                    sh 'docker --version || { echo "Docker non installé"; exit 1; }'
                    sh 'docker-compose --version || { echo "Docker Compose non installé"; exit 1; }'
                    sh 'docker ps'
                }
            }
        }

        stage('Construire l\'image Docker avec Ansible') {
            steps {
                script {
                    echo "🔨 Build de l'image ${DOCKER_IMAGE}"
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Construire les conteneurs') {
            steps {
                script {
                    echo "⚙️ Construction des conteneurs via docker-compose"
                    sh 'docker-compose down --remove-orphans || true'
                    sh 'docker-compose build'
                }
            }
        }

        stage('Lancer l\'application') {
            steps {
                script {
                    echo "🚀 Lancement de l'application avec docker-compose"
                    sh 'docker-compose up -d'  // Lancer les conteneurs définis dans docker-compose.yml
                }
            }
        }

        stage('Vérification de la présence du playbook.yml') {
            steps {
                script {
                    echo "🔎 Vérification de la présence de playbook.yml dans ${DEPOLOY_DIR}"

                    // Ajout de débogage pour vérifier l'état du répertoire de déploiement
                    sh """
                        docker run --rm \\
                            -v "${DEPOLOY_DIR}:/ansible" \\
                            -w /ansible \\
                            ${DOCKER_IMAGE} \\
                            /bin/bash -c 'echo "Workspace: ${DEPOLOY_DIR}" && env && ls -al /ansible && test -f playbook.yml && echo "✅ Playbook trouvé" || { echo "❌ Playbook introuvable"; exit 1; }'
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    echo "📦 Déploiement du playbook depuis ${DEPOLOY_DIR}"

                    // Exécution de l'ansible playbook avec volume monté
                    sh """
                        docker run --rm \\
                            -v "${DEPOLOY_DIR}:/ansible" \\
                            -w /ansible \\
                            ${DOCKER_IMAGE} \\
                            ansible-playbook playbook.yml
                    """
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                echo "🧪 Aucun test défini pour le moment."
            }
        }

        stage('Nettoyage') {
            steps {
                echo "🧹 Nettoyage éventuel des ressources..."
            }
        }
    }

    post {
        failure {
            echo "❌ Le pipeline a échoué."
        }
        success {
            echo "✅ Le pipeline a réussi."
        }
    }
}
