pipeline {
	agent any

  environment {
		TF_IN_AUTOMATION = "true"
		VAULT_ADDR = 'http://vault:8200'
  }

  parameters {
		choice(
      name: 'TF_ACTION',
      choices: ['apply', 'destroy'],
      description: 'What do you want this pipeline to do?'
    )
  }

  stages {
		stage('Fetch path from Vault') {
            steps {
                withCredentials([string(credentialsId: 'vault-token', variable: 'VAULT_TOKEN')]) {
                    sh '''
                      echo "Create secrets directory.."
                      mkdir -p secrets
                   	  echo "Fetching GCP credentials path from Vault..."

                      # KV v2: secret/data/gcp, поле credentials_path
                      GCP_PATH=$(curl -s \
                        --header "X-Vault-Token: $VAULT_TOKEN" \
                        "$VAULT_ADDR/v1/secret/data/gcp" \
                        | jq -r '.data.data["sa-key-path"]')

                      echo "Got path from Vault: $GCP_PATH"

                      # Записуємо env для наступних stage-ів
                      echo "export TF_VAR_gcp_credentials_file=$GCP_PATH"   >  secrets/tf_env.sh
					  echo "export GOOGLE_APPLICATION_CREDENTIALS=$GCP_PATH" >> secrets/tf_env.sh

                    '''
                }
            }
        }

		stage('Terraform init') {
			steps {
				sh '''
			. secrets/tf_env.sh
            cd terraform
            terraform init
        '''
      }
    }

    stage('Terraform plan') {
			steps {
				sh '''
			. secrets/tf_env.sh
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
			. secrets/tf_env.sh
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
        	. secrets/tf_env.sh
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
				. secrets/tf_env.sh
				cd terraform

				# Get TF output as JSON
				terraform output -json vm_public_ips_by_name > /tmp/vm_ips.json

				cd ..

				PRIVATE_KEY="/var/jenkins_home/data/id_ed25519"

				# Build known_hosts from all public IPs
				jq -r '.[]' /tmp/vm_ips.json | while read ip; do
				  echo "Waiting for SSH to become available on $ip..."

				  # Wait until port 22 is open
				  while ! nc -z "$ip" 22 2>/dev/null; do
					sleep 5
				  done

				  echo "SSH is up on $ip, scanning host key..."
				  ssh-keyscan -H "$ip" >> ~/.ssh/known_hosts 2>/dev/null || true
				done

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