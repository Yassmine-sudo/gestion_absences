pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-app-with-ansible"
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

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    if (fileExists('deploiement/playbook.yml')) {
                        echo "Le playbook.yml existe, on peut lancer Ansible."
                        sh """
                            docker run --rm \
                                -v "\$(pwd)/deploiement:/ansible" \
                                -w /ansible \
                                ${DOCKER_IMAGE} /bin/bash -c "ls -al && ansible-playbook playbook.yml"
                        """
                    } else {
                        error("Le fichier playbook.yml est introuvable dans le dossier 'deploiement'")
                    }
                }
            }
        }

        // Section 'Exécuter les tests' supprimée, car tu ne souhaites pas l'avoir maintenant
        // stage('Exécuter les tests (si applicable)') {
        //     when {
        //         expression { fileExists('tests') }
        //     }
        //     steps {
        //         echo "Exécution des tests (à implémenter selon le projet)"
        //         // sh "pytest" ou autre selon ton projet
        //     }
        // }

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
