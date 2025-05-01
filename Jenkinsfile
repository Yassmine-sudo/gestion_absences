pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-app-with-ansible"
        DEPLOY_DIR = "${env.WORKSPACE}/deploiement"
    }

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
                    sh "docker build -t ${DOCKER_IMAGE} ."
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
                    def containerExists = sh(script: "docker ps -a -q -f name=jenkins-test", returnStdout: true).trim()
                    if (containerExists) {
                        echo "Le conteneur 'jenkins-test' existe déjà, on le laisse tourner."
                    } else {
                        sh "docker compose up -d"
                    }
                }
            }
        }

        stage('Vérification de la présence du playbook.yml') {
            steps {
                script {
                    echo "Vérification de la présence du playbook.yml dans le répertoire Jenkins..."

                    // Lister les fichiers dans le répertoire deploy de Jenkins
                    sh "ls -al ${DEPLOY_DIR}"

                    echo "Vérification de la présence du playbook.yml dans le conteneur..."

                    sh """
                        docker run --rm \
                            -v "${DEPLOY_DIR}:/ansible" \
                            -w /ansible \
                            ${DOCKER_IMAGE} \
                            /bin/bash -c "ls -al /ansible && test -f /ansible/playbook.yml && echo 'Playbook trouvé' || echo 'Playbook introuvable'"
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    if (fileExists("${DEPLOY_DIR}/playbook.yml")) {
                        echo "Le playbook.yml existe, on peut lancer Ansible."
                        sh """
                            docker run --rm \
                                -v "${DEPLOY_DIR}:/ansible" \
                                -w /ansible \
                                ${DOCKER_IMAGE} /bin/bash -c "ansible-playbook playbook.yml"
                        """
                    } else {
                        error("Le fichier playbook.yml est introuvable dans le dossier 'deploiement'")
                    }
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            when {
                expression { fileExists('tests') }
            }
            steps {
                echo "Exécution des tests (à implémenter selon le projet)"
                // sh "pytest" ou autre selon ton projet
            }
        }

        stage('Nettoyage') {
            steps {
                echo "Nettoyage terminé"
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
