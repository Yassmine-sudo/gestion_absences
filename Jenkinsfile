pipeline {
    agent any

    environment {
        COMPOSE_PROJECT_NAME = 'ci_project'
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                script {
                    // Cloner le dépôt depuis GitHub
                    git url: 'https://github.com/Yassmine-sudo/gestion_absences.git', branch: 'master'
                }
                // Lister les fichiers du dépôt pour s'assurer que tout a bien été cloné
                sh 'ls -la'  
            }
        }

        stage('Vérification Docker') {
            steps {
                // Vérifier si Docker est installé et accessible
                sh 'which docker || echo "Docker non installé !"'
                // Vérifier si Docker Compose est installé
                sh 'which docker-compose || echo "Docker Compose non installé !"'
                // Vérifier la version de Docker
                sh 'docker --version || echo "Docker non trouvé !"'
                // Vérifier la version de Docker Compose
                sh 'docker compose version || echo "Docker Compose non trouvé !"'
                // Afficher toutes les variables d'environnement pour débogage
                sh 'env'
            }
        }

        stage('Construire les conteneurs') {
            steps {
                // Arrêter et supprimer les conteneurs existants
                sh 'docker compose -f docker-compose.yml down --remove-orphans || true'
                // Construire les nouveaux conteneurs
                sh 'docker compose -f docker-compose.yml build || echo "Erreur lors de la construction des conteneurs !"'
            }
        }

        stage('Lancer l\'application') {
            steps {
                // Lancer les conteneurs en mode détaché
                sh 'docker compose -f docker-compose.yml up -d || echo "Erreur lors du démarrage des conteneurs !"'
                // Attendre que les services démarrent correctement
                sh 'sleep 10'  // Attendre que les services démarrent
                // Vérifier que les conteneurs sont bien en cours d'exécution
                sh 'docker ps || echo "Aucun conteneur en cours d\'exécution !"'
            }
        }

        stage('Exécuter les tests (si applicable)') {
            steps {
                // Exécuter les tests dans le conteneur si des tests sont définis
                // Ici, on utilise un message générique, à adapter si tu as des tests spécifiques
                sh 'docker compose exec -T app echo "Pas de tests définis pour le moment"'
            }
        }

        stage('Nettoyage') {
            steps {
                // Nettoyer en supprimant les conteneurs
                sh 'docker compose -f docker-compose.yml down || echo "Erreur lors du nettoyage des conteneurs !"'
            }
        }
    }

    post {
        always {
            // Afficher un message indiquant que le pipeline est terminé
            echo 'Pipeline terminé.'
        }

        success {
            // Afficher un message de succès
            echo 'Le pipeline s\'est terminé avec succès !'
        }

        failure {
            // Afficher un message en cas d\'échec
            echo 'Le pipeline a échoué.'
        }
    }
}
