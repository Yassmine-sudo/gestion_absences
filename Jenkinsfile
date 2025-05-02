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
                    def ws = sh(script: 'pwd', returnStdout: true).trim()
                    echo "🔎 Vérification du playbook dans ${ws}/deploiement"

                    sh """
                        docker run --rm \\
                            -v "${ws}/deploiement:/ansible" \\
                            -w /ansible \\
                            ${DOCKER_IMAGE} \\
                            /bin/bash -c 'ls -al && test -f playbook.yml && echo "✅ Playbook trouvé" || { echo "❌ Playbook introuvable"; exit 1; }'
                    """
                }
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    def ws = sh(script: 'pwd', returnStdout: true).trim()
                    echo "📦 Déploiement du playbook depuis ${ws}/deploiement"
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
