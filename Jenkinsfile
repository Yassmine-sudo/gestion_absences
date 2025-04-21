pipeline {
    agent any

    triggers {
        githubPush()
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Yassmine-sudo/gestion_absences.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "🔧 Installation de Node.js et des dépendances..."
                sh '''
                    # Installer Node.js v18 (moderne et stable)
                    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
                    apt-get update
                    apt-get install -y nodejs

                    # Vérification
                    node -v
                    npm -v

                    # Installer les dépendances du projet
                    npm install
                '''
            }
        }

        stage('Build') {
            steps {
                echo "🛠️ Build (non personnalisé pour le moment)"
                sh 'echo "Pas de build spécifique encore."'
            }
        }

        stage('Test') {
            steps {
                echo "🧪 Tests (non configurés pour le moment)"
                sh 'echo "Pas de tests définis."'
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Déploiement (placeholder)"
                sh 'echo "Pas encore de stratégie de déploiement définie."'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline terminée avec succès !'
        }
        failure {
            echo '❌ Pipeline échouée.'
        }
    }
}
