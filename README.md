
# Running Terraform from dev laptop
docker run -i -t hashicorp/terraform:latest plan


### TF Ddebuging Env levels 
export TF_LOG=DEBUG
export TF_LOG=ERROR
export TF_LOG=INFO
export TF_LOG=WARN
export TF_LOG=TRACE