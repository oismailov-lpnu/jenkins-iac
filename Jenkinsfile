pipeline {
    agent any

    stages {
        stage('Terraform PLan') {
            steps {
                sh '''
                  cd terraform
                  terraform init
                '''
            }
        }
        stage('Terraform Init') {
            steps {
                sh '''
                  cd terraform
                  terraform plan
                '''
            }
        }
         stage('Terraform apply') {
            steps {
                sh '''
                  cd terraform
                  terraform apply -auto-approve
                '''
            }
        }
    }
}
