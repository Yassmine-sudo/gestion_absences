pipeline {
    agent any

    environment {
        DOCKER_BUILDKIT = '1'
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                checkout scm // <-- récupère depuis GitHub automatiquement
                script {
                    sh 'git fetch --all'
                    sh 'git reset --hard origin/master'
                }
            }
        }

        stage('Vérification Docker') {
            steps {
                script {
                    sh 'command -v docker || { echo "Docker introuvable"; exit 1; }'
                    sh 'docker --version'
                    sh 'docker compose version || docker-compose --version'
                }
            }
        }

        stage('Construire l\'image Docker avec Ansible') {
            steps {
                script {
                    sh 'docker build -t my-app-with-ansible .'
                }
            }
        }

        stage('Construire les conteneurs') {
            steps {
                script {
                    sh 'docker compose down --remove-orphans || true'
                    sh 'docker compose build'
                }
            }
        }

        stage('Lancer l\'application') {
            steps {
                script {
                    def containerExists = sh(
                        script: "docker ps -a -q -f name=jenkins-test",
                        returnStdout: true
                    ).trim()
                    if (containerExists) {
                        echo "Le conteneur 'jenkins-test' existe déjà, on le laisse tourner."
                        sh 'docker start jenkins-test || true'
                    } else {
                        echo "Le conteneur 'jenkins-test' n'existe pas encore. Lancement via docker-compose."
                        sh 'docker compose up -d'
                    }
                }
            }
        }

        stage('Vérification de la présence du playbook.yml') {
            steps {
                script {
                    echo "Vérification de la présence du playbook.yml dans le répertoire Jenkins..."
                    sh "ls -al \"$WORKSPACE/deploiement\""

                    echo "Vérification dans le conteneur Ansible..."
                    sh """
                        docker run --rm \
                            -v "$WORKSPACE/deploiement:/ansible" \
                            -w /ansible \
                            my-app-with-ansible \
                            /bin/bash -c 'ls -al /ansible && test -f /ansible/playbook.yml && echo Playbook trouvé || { echo Playbook introuvable; exit 1; }'
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    echo "Lancement du playbook Ansible"
                    sh """
                        docker run --rm \
                            -v "$WORKSPACE/deploiement:/ansible" \
                            -w /ansible \
                            my-app-with-ansible \
                            ansible-playbook playbook.yml
                    """
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                echo "Tests non définis pour l’instant."
            }
        }

        stage('Nettoyage') {
            steps {
                echo "Nettoyage des ressources si nécessaire..."
                // Exemple si besoin : sh 'docker system prune -f'
            }
        }
    }

    post {
        failure {
            echo '❌ Le pipeline a échoué.'
        }
        success {
            echo '✅ Le pipeline a réussi.'
        }
    }
}
