pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-app-with-ansible'  // Nom de l'image Docker créée
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
                    // Récupérer les derniers changements
                    sh 'git fetch --all'
                    sh 'git reset --hard origin/master'
                }
            }
        }

        stage('Vérification Docker') {
            steps {
                script {
                    // Vérifier si Docker est installé
                    sh 'which docker'
                    sh 'docker --version'
                    sh 'docker compose version'
                }
            }
        }

        stage('Construire l\'image Docker avec Ansible') {
            steps {
                script {
                    // Construire l'image Docker
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Construire les conteneurs') {
            steps {
                script {
                    // Construire les conteneurs Docker
                    sh 'docker compose down --remove-orphans'
                    sh 'docker compose build'
                }
            }
        }

        stage('Lancer l\'application') {
            steps {
                script {
                    // Vérifier si le conteneur existe déjà
                    def containerExists = sh(script: "docker ps -a -q -f name=jenkins-test", returnStdout: true).trim()
                    if (containerExists) {
                        echo "Le conteneur 'jenkins-test' existe déjà, on le laisse tourner."
                    } else {
                        echo "Le conteneur 'jenkins-test' n'existe pas, on va le créer."
                    }
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    // Définir le chemin du playbook
                    def playbookPath = '/var/jenkins_home/workspace/test-compose/deploiement/playbook.yml'

                    // Vérifier l'existence du fichier playbook.yml avant d'exécuter Ansible
                    if (fileExists(playbookPath)) {
                        echo "Le playbook.yml existe, on peut lancer Ansible."
                        sh """
                            docker run --rm \
                                -v /var/jenkins_home/workspace/test-compose:/workspace \
                                -w /workspace/deploiement \
                                ${DOCKER_IMAGE} ansible-playbook /workspace/deploiement/playbook.yml
                        """
                    } else {
                        error "Le playbook.yml est introuvable dans le répertoire attendu."
                    }
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            when {
                expression { return currentBuild.result == null }
            }
            steps {
                echo "Les tests sont exécutés ici si nécessaire."
            }
        }

        stage('Nettoyage') {
            steps {
                echo "Cette étape est réservée au nettoyage."
            }
        }

        stage('Declarative: Post Actions') {
            steps {
                echo "Pipeline terminé."
                script {
                    if (currentBuild.result == 'FAILURE') {
                        echo "Le pipeline a échoué."
                    } else {
                        echo "Le pipeline a réussi."
                    }
                }
            }
        }
    }
}
