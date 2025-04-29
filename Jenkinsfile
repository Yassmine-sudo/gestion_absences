pipeline {
    agent any

    environment {
        COMPOSE_PROJECT_NAME = 'ci_project'
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git url: 'https://github.com/Yassmine-sudo/gestion_absences.git', branch: 'master'
                sh 'ls -la'
            }
        }
        stage('Vérification Docker') {
            steps {
                sh 'which docker'
                sh 'which docker compose'
                sh 'docker --version'
                sh 'docker compose version'
                sh 'env'
            }
        }

        stage('Construire les conteneurs') {
            steps {
                sh 'docker compose -f docker-compose.yml down || true'
                sh 'docker compose -f docker-compose.yml build'
            }
        }

        stage('Lancer l\'application') {
            steps {
                sh 'docker compose -f docker-compose.yml up -d'
                sh 'sleep 10' // attendre que les services démarrent
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                // Exemple générique — adapte-le si tu as des tests à exécuter dans le conteneur
                sh 'docker compose exec -T app echo "Pas de tests définis pour le moment"'
            }
        }

        stage('Nettoyage') {
            steps {
                sh 'docker compose -f docker-compose.yml down'
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}