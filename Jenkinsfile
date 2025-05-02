pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-app-with-ansible"
        DEPLOY_DIR = "${WORKSPACE}/deploiement"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                checkout scm
                script {
                    echo "🔄 Reset du dépôt sur origin/master"
                    sh 'git fetch --all'
                    sh 'git reset --hard origin/master'
                }
            }
        }

        stage('Vérification Docker') {
            steps {
                script {
                    echo "🐳 Vérification de Docker et Docker Compose"
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
                    echo "⚙️ Construction via docker-compose"
                    sh 'docker-compose down --remove-orphans || true'
                    sh 'docker-compose build'
                }
            }
        }

        stage('Lancer l\'application') {
            steps {
                script {
                    def containerExists = sh(script: "docker ps -a -q -f name=jenkins-test", returnStdout: true).trim()
                    if (containerExists) {
                        echo "🔁 Redémarrage du conteneur existant"
                        sh 'docker start jenkins-test || true'
                    } else {
                        echo "🚀 Lancement via docker-compose"
                        sh 'docker-compose up -d'
                    }
                }
            }
        }

        stage('Vérification de la présence de playbook.yml') {
            steps {
                script {
                    echo "🔍 Vérification de playbook.yml dans ${DEPLOY_DIR}"

                    sh """
                        docker run --rm \\
                            -v "${WORKSPACE}:/workspace:rw" \\
                            -w /workspace \\
                            ${DOCKER_IMAGE} \\
                            /bin/bash -c '
                                echo "📁 Contenu de /workspace/deploiement :"
                                ls -al deploiement
                                if [ -f deploiement/playbook.yml ]; then
                                    echo "✅ Playbook trouvé"
                                else
                                    echo "❌ playbook.yml manquant"; exit 1
                                fi
                            '
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    echo "📦 Exécution du playbook"

                    sh """
                        docker run --rm \\
                            -v "${WORKSPACE}:/workspace:rw" \\
                            -v "$HOME/.ssh:/root/.ssh:ro" \\
                            -e ANSIBLE_HOST_KEY_CHECKING=False \\
                            -w /workspace \\
                            ${DOCKER_IMAGE} \\
                            ansible-playbook deploiement/playbook.yml
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
