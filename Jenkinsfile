pipeline {
    agent {
        docker {
            image 'node:18'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Yassmine-sudo/gestion_absences.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
            }
        }
    }
}
