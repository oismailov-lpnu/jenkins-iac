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
            terraform apply -auto-approve
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

    stage('Generate Ansible inventory') {
			when {
				expression { params.TF_ACTION == 'apply' }
    }
		steps {
					sh '''
				cd terraform

				# Get TF output as JSON
				terraform output -json vm_public_ips_by_name > /tmp/vm_ips.json

				cd ..

				PRIVATE_KEY="/var/jenkins_home/data/id_ed25519"

				echo "[web]" > ansible/inventory.ini

				# Correct jq command without Groovy escaping problems
				jq -r "to_entries[] | .key + \\" ansible_host=\\" + .value + \\" ansible_user=ubuntu ansible_ssh_private_key_file=${PRIVATE_KEY}\\"" /tmp/vm_ips.json >> ansible/inventory.ini

				echo "Generated inventory:"
				cat ansible/inventory.ini

				echo "Running Ansible playbook..."
                ansible-playbook -i ansible/inventory.ini ansible/site.yml
			'''
		}
	}
  }
}