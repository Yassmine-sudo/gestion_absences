pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-app-with-ansible'
        WORKDIR = 'deploiement'
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
                    sh 'command -v docker'
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
                    sh 'docker compose down --remove-orphans'
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
                        sh 'docker start jenkins-test'
                    } else {
                        sh 'docker compose up -d'
                    }
                }
            }
        }

        stage('Vérification de la présence du playbook.yml') {
            steps {
                script {
                    echo 'Vérification de la présence du playbook.yml dans le répertoire Jenkins...'
                    sh "ls -al ${WORKDIR}"
                    sh "cat ${WORKDIR}/playbook.yml"

                    echo 'Vérification dans le conteneur Ansible...'
                    sh """
                        docker run --rm \
                            -v "\$(pwd)/${WORKDIR}:/ansible" \
                            -w /ansible \
                            ${DOCKER_IMAGE} \
                            /bin/bash -c 'ls -al /ansible && test -f /ansible/playbook.yml && echo Playbook trouvé || { echo Playbook introuvable; exit 1; }'
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            when {
                expression {
                    fileExists("${WORKDIR}/playbook.yml")
                }
            }
            steps {
                script {
                    sh """
                        docker run --rm \
                            -v "\$(pwd)/${WORKDIR}:/ansible" \
                            -w /ansible \
                            ${DOCKER_IMAGE} \
                            ansible-playbook playbook.yml
                    """
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                echo 'Aucun test défini pour l’instant.'
            }
        }

        stage('Nettoyage') {
            steps {
                echo 'Nettoyage terminé (pas encore implémenté).'
            }
        }
    }

    post {
        failure {
            echo '❌ Le pipeline a échoué.'
        }
        success {
            echo '✅ Pipeline terminé avec succès.'
        }
    }
}
