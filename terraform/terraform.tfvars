project_id      = "jenkins-iac-480517"
region          = "europe-west1"
zone            = "europe-west1-b"
instance_count  = 1

ssh_username    = "ubuntu"
ssh_public_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDzCZKnAXY2QFS91bCCSmjikIiBmE8OTkapH6ap+QPi jenkins@iac"
ssh_source_cidr = "0.0.0.0/0" # for lab; later you can restrict to your IP
