pipeline {
    agent any

    stages {
        stage('Terraform Init') {
            steps {
                sh '''
                  cd terraform
                  terraform init
                '''
            }
        }
    }
}
