pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-app-with-ansible"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                checkout scm
                script {
                    sh 'git fetch --all'
                    sh 'git reset --hard origin/master'
                }
            }
        }

        stage('Vérification Docker') {
            steps {
                script {
                    echo "Vérification Docker et Docker Compose"
                    sh 'docker --version'
                    sh 'docker-compose --version'
                    sh 'docker ps'
                }
            }
        }

        stage('Construire l\'image Docker avec Ansible') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Construire les conteneurs') {
            steps {
                script {
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
                        echo "Le conteneur 'jenkins-test' existe déjà."
                        sh 'docker start jenkins-test || true'
                    } else {
                        echo "Le conteneur 'jenkins-test' n'existe pas encore. Lancement via docker-compose."
                        sh 'docker-compose up -d'
                    }
                }
            }
        }

        stage('Vérification de la présence du playbook.yml') {
            steps {
                script {
                    def ws = sh(script: 'pwd', returnStdout: true).trim()
                    echo "Workspace: ${ws}"

                    echo "Contenu du répertoire 'deploiement' (sur Jenkins) :"
                    sh "ls -al ${ws}/deploiement"

                    echo "Vérification dans le conteneur Ansible..."
                    sh """
                        docker run --rm \\
                            -v "${ws}/deploiement:/ansible" \\
                            -w /ansible \\
                            ${DOCKER_IMAGE} \\
                            /bin/bash -c 'ls -al && test -f playbook.yml && echo "Playbook trouvé" || { echo "Playbook introuvable"; exit 1; }'
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    def ws = sh(script: 'pwd', returnStdout: true).trim()
                    echo "Déploiement avec Ansible, workspace: ${ws}"
                    sh """
                        docker run --rm \\
                            -v "${ws}/deploiement:/ansible" \\
                            -w /ansible \\
                            ${DOCKER_IMAGE} \\
                            ansible-playbook playbook.yml
                    """
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                echo "Tests non définis pour l'instant."
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
            echo "❌ Le pipeline a échoué."
        }
        success {
            echo "✅ Le pipeline a réussi."
        }
    }
}
