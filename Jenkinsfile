pipeline {
    agent {
        docker {
            image 'node:18' // image officielle Node.js avec npm inclus
        }
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Yassmine-sudo/gestion_absences.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "🔧 Installation des dépendances..."
                sh '''
                    node -v
                    npm -v
                    npm install
                '''
            }
        }

        stage('Build') {
            steps {
                echo "🛠️ Build..."
                sh 'echo "Build en attente de script..."'
            }
        }

        stage('Test') {
            steps {
                echo "🧪 Tests..."
                sh 'echo "Tests en attente de configuration..."'
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Déploiement..."
                sh 'echo "Déploiement non défini..."'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline OK !'
        }
        failure {
            echo '❌ Pipeline échouée.'
        }
    }
}
