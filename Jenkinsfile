pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = "true"
  }

  parameters {
    choice(
      name: 'TF_ACTION',
      choices: ['apply', 'destroy'],
      description: 'What do you want this pipeline to do?'
    )
  }

  stages {
    stage('Terraform init') {
      steps {
        sh '''
            cd terraform
            terraform init
        '''
      }
    }

    stage('Terraform plan') {
      steps {
        sh '''
            cd terraform
            terraform plan
        '''
      }
    }

    stage('Terraform apply') {
      when {
        expression {
          params.TF_ACTION == 'apply'
        }
      }
      steps {
        sh '''
            cd terraform
            terraform apply - auto - approve
        '''
      }
    }

    stage('Terraform destroy (manual)') {
      when {
        expression {
          params.TF_ACTION == 'destroy'
        }
      }

      steps {
        // Manual confirmation step
        script {
            input message: 'Are you absolutely sure you want to run terraform destroy?', ok: 'Yes, destroy'
        }

        sh '''
            cd terraform
            terraform destroy -auto-approve
        '''
      }
    }
  }
}