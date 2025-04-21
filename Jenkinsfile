pipeline {
    agent any
    stages {
        stage('Test Git') {
            steps {
                git url: 'https://github.com/Yassmine-sudo/gestion_absences.git', branch: 'master'
                sh 'ls -la'
            }
        }
    }
}
