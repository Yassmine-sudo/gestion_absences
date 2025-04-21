pipeline {
    agent any  // Utilise n'importe quel agent Jenkins disponible

    triggers {
        githubPush()  // Déclenche la pipeline à chaque push sur GitHub
    }

    options {
        timestamps()  // Ajoute des horodatages à chaque étape de la pipeline
    }

    stages {
        stage('Checkout') {
            steps {
                // Utilisation de l'URL HTTPS pour récupérer le code
                git url: 'https://github.com/Yassmine-sudo/gestion_absences.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo '🔧 Installation des dépendances avec npm...'
                // Installation des dépendances avec npm
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                echo '🏗️  Phase de construction...'
                // Adapte cette étape selon tes besoins spécifiques de build (si nécessaire)
                sh 'echo "Aucune étape de build spécifique pour ce projet."'
            }
        }

        stage('Test') {
            steps {
                echo '🧪 Phase de test...'
                // Tu peux ajouter tes tests ici si tu en as (ex: Jest pour Node.js)
                sh 'echo "Pas encore de tests définis pour ce projet."'
            }
        }

        stage('Deploy') {
            steps {
                echo '🚀 Phase de déploiement...'
                // Adapte cette étape en fonction de ton processus de déploiement (Docker, Kubernetes...)
                sh 'echo "Pas encore de déploiement configuré."'
            }
        }
    }

    post {
        success {
            echo '✅ La pipeline a été a échoué !'
        }
    }
}
