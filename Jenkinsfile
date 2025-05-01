pipeline {
    agent any

    stages {
        stage('Cloner le dépôt') {
            steps {
                script {
                    sh 'git fetch --all'
                    sh 'git reset --hard origin/master'
                }
            }
        }

        stage('Vérification Docker') {
            steps {
                script {
                    sh 'which docker'
                    sh 'docker --version'
                    sh 'docker compose version'
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
                    sh 'docker compose down --remove-orphans'
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
                    } else {
                        echo "Le conteneur 'jenkins-test' n'existe pas encore."
                    }
                }
            }
        }

        stage('Vérification de la présence du playbook.yml') {
            steps {
                script {
                    echo "Vérification de la présence du playbook.yml dans le répertoire Jenkins..."
                    sh "ls -al $WORKSPACE/deploiement"

                    echo "Vérification de la présence du playbook.yml dans le conteneur..."
                    sh """
                        docker run --rm \
                            -v "$WORKSPACE/deploiement:/ansible" \
                            -w /ansible \
                            my-app-with-ansible \
                            /bin/bash -c 'ls -al /ansible && test -f /ansible/playbook.yml && echo Playbook trouvé || echo Playbook introuvable'
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    echo "Le playbook.yml existe, on peut lancer Ansible."
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
            }
        }
    }

    post {
        failure {
            echo 'Le pipeline a échoué.'
        }
        success {
            echo 'Le pipeline a réussi.'
        }
    }
}
