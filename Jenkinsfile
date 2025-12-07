pipeline {
    agent any

    stages {
        stage('Terraform Init') {
            steps {
                sh '''
                  cd terraform
                  terraform init
                  terraform plan
                  terraform apply -auto-approve
                '''
            }
        }
    }
}
