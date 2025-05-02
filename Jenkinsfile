pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-app-with-ansible"
        DEPLOY_DIR = "${WORKSPACE}/deploiement"  // Répertoire local pour le déploiement
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
                    def containerExists = sh(script: "docker ps -a -q -f name=jenkins-test", returnStdout: true).trim()
                    if (containerExists) {
                        echo "🔁 Le conteneur 'jenkins-test' existe déjà. Redémarrage..."
                        sh 'docker start jenkins-test || true'
                    } else {
                        echo "🚀 Lancement de l'application avec docker-compose"
                        sh 'docker-compose up -d'
                    }
                }
            }
        }

        stage('Vérification de la présence du playbook.yml') {
            steps {
                script {
                    echo "🔎 Vérification de la présence de playbook.yml dans ${DEPLOY_DIR}"

                    sh """
                        docker run --rm \\
                            -v "${DEPLOY_DIR}:/workspace/deploiement:rw" \\
                            -w /workspace/deploiement \\
                            ${DOCKER_IMAGE} \\
                            /bin/bash -c 'echo "Workspace: ${DEPLOY_DIR}" && env && ls -al /workspace/deploiement && test -f playbook.yml && echo "✅ Playbook trouvé" || { echo "❌ Playbook introuvable"; exit 1; }'
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    echo "📦 Déploiement du playbook depuis ${DEPLOY_DIR}"

                    sh """
                        docker run --rm \\
                            -v "${DEPLOY_DIR}:/workspace/deploiement:rw" \\
                            -w /workspace/deploiement \\
                            ${DOCKER_IMAGE} \\
                            /opt/ansible-venv/bin/ansible-playbook playbook.yml
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
