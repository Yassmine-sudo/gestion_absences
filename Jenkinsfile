pipeline {
    agent any

    environment {
        COMPOSE_PROJECT_NAME = 'ci_project'
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                script {
                    git url: 'https://github.com/Yassmine-sudo/gestion_absences.git', branch: 'master'
                }
                sh 'ls -la'
                sh 'git log -1 --oneline'
            }
        }

        stage('Vérification Docker') {
            steps {
                sh 'which docker || echo "Docker non installé !"'
                sh 'which docker-compose || echo "Docker Compose non installé !"'
                sh 'docker --version || echo "Docker non trouvé !"'
                sh 'docker compose version || echo "Docker Compose non trouvé !"'
                sh 'env'
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
                sh 'docker compose down --remove-orphans || true'
                sh 'docker compose build || echo "Erreur lors de la construction des conteneurs !"'
            }
        }

        stage('Lancer l\'application') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    sh '''
                    if [ ! "$(docker ps -a -q -f name=jenkins-test)" ]; then
                        docker compose up -d
                    else
                        echo "Le conteneur 'jenkins-test' existe déjà, on le laisse tourner."
                    fi
                    '''
                }
                sh 'sleep 10'
                sh 'docker ps || echo "Aucun conteneur en cours d\'exécution !"'
            }
        }

        stage('Déploiement avec Ansible') {
            steps {
                script {
                    // Ajouter une étape pour vérifier que le fichier playbook.yml existe dans le répertoire de déploiement
                    sh 'ls -la /var/jenkins_home/workspace/${JOB_NAME}/deploiement || echo "Le dossier de déploiement est vide !"'
                    
                    // Utilisation de "docker run" avec une vérification préalable de l'existence du fichier playbook.yml
                    sh '''
                    if [ -f /var/jenkins_home/workspace/${JOB_NAME}/deploiement/playbook.yml ]; then
                        echo "Le playbook.yml existe, on peut lancer Ansible."
                        docker run --rm -v /var/jenkins_home/workspace/${JOB_NAME}:/workspace -w /workspace/deploiement my-app-with-ansible ansible-playbook /workspace/deploiement/playbook.yml
                    else
                        echo "Erreur : Le fichier playbook.yml est introuvable !"
                        exit 1
                    fi
                    '''
                }
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                echo 'Pas de tests définis pour le moment.'
            }
        }

        stage('Nettoyage') {
            steps {
                script {
                    sh '''
                    docker ps -a --format "{{.Names}}" | grep -v jenkins-test | while read container; do
                        docker rm -f "$container" || echo "Échec suppression $container"
                    done
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }

        success {
            echo 'Le pipeline s\'est terminé avec succès !'
        }

        failure {
            echo 'Le pipeline a échoué.'
        }
    }
}
