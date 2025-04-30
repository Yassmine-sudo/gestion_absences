pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-app-with-ansible'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Cloner le dépôt') {
            steps {
                script {
                    // Récupérer les dernières modifications du dépôt
                    sh 'git fetch --all'
                    sh 'git reset --hard origin/master'
                }
            }
        }

        stage('Vérification Docker') {
            steps {
                script {
                    // Vérification de la présence de Docker et Docker Compose
                    sh 'which docker || echo Docker non trouvé !'
                    sh 'docker --version'
                    sh 'docker compose version || echo Docker Compose non installé !'
                }
            }
        }

        stage('Construire l\'image Docker avec Ansible') {
            steps {
                script {
                    // Construire l'image Docker avec le Dockerfile
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Construire les conteneurs') {
            steps {
                script {
                    // Construire les conteneurs avec Docker Compose
                    sh 'docker compose down --remove-orphans || echo "Aucun conteneur à arrêter"'
                    sh 'docker compose build'
                }
            }
        }

        stage('Lancer l\'application') {
            steps {
                script {
                    // Vérifier si le conteneur existe déjà
                    def containerId = sh(script: 'docker ps -a -q -f name=jenkins-test', returnStdout: true).trim()
                    if (containerId) {
                        echo "Le conteneur 'jenkins-test' existe déjà, on le laisse tourner."
                    } else {
                        echo "Lancer le conteneur jenkins-test."
                        sh 'docker-compose up -d'
                    }
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    // Vérification de l'existence du playbook.yml
                    def playbook = '/var/jenkins_home/workspace/test-compose/deploiement/playbook.yml'
                    if (fileExists(playbook)) {
                        echo "Le playbook.yml existe, on peut lancer Ansible."
                        sh """
                            docker run --rm \
                                -v /var/jenkins_home/workspace/test-compose:/workspace \
                                -w /workspace/deploiement \
                                ${DOCKER_IMAGE} ansible-playbook /workspace/deploiement/playbook.yml
                        """
                    } else {
                        error "Le playbook.yml est introuvable."
                    }
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                echo "Les tests seront exécutés ici, si applicable."
            }
        }

        stage('Nettoyage') {
            steps {
                echo "Nettoyage effectué ici, si nécessaire."
            }
        }
    }

    post {
        always {
            echo "Pipeline terminé."
        }
        failure {
            echo "Le pipeline a échoué."
        }
    }
}
