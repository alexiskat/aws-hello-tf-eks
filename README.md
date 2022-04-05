# Introduction
This repo can be used to deploy a  ```hello world``` to AWS EKS using terraform.

### Setup AWs Accounts with GH Actions 
https://benoitboure.com/securely-access-your-aws-resources-from-github-actions

# PreRequisites 
 [aws-vault](https://github.com/99designs/aws-vault) must be installed on your local machine and a ```user``` must be configured for each environment you plan to deploy to ```dev|qa|prod```.
 [docker](https://docs.docker.com/get-docker/) must also be installed on the local machine
 [AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) must also be installed on the local machine

# AWS-Vault
### Basic CMD
```sh
aws-vault add alexis-mng
aws-vault list
aws-vault exec alexis-mng -- env | grep AWS
aws-vault clear alexis-mng
aws-vault remove alexis-mng --sessions-only
```
Remeber the user default setting like region still need to be configure at ```vi ~/.aws/config```
```
[profile alexis-mng]
region=eu-west-1
mfa_serial=arn:aws:iam::xxx:mfa/alexis-mng
```
# Docker
### Get the Hashicorp Docker Image
```sh
docker pull hashicorp/terraform:light
docker pull hashicorp/terraform:0.14.6
```
### Run the container
```sh
docker run -v `pwd`:/workspace -w /workspace hashicorp/terraform:light init
docker run -v `pwd`:/workspace -w /workspace hashicorp/terraform:light apply
docker run -v `pwd`:/workspace -w /workspace hashicorp/terraform:light destroy
```
The flags
  - The ```-v``` option mounts your current working directory into the container’s /workspace directory.
  - The ```-w``` flag creates the /workspace directory and sets it as the new working directory, overwriting the terraform image’s original.
Use the following to check this: ```docker run -v `pwd`:/workspace -w /workspace --entrypoint /bin/sh hashicorp/terraform:light -c pwd```

Thanks to Victor Leong blog [artical](https://www.vic-l.com/terraform-with-docker) for the above

# Terraform
### TF Ddebuging Env levels
```
export TF_LOG=DEBUG
export TF_LOG=ERROR
export TF_LOG=INFO
export TF_LOG=WARN
export TF_LOG=TRACE
```
### Terraform, Docker and aws-vault
All the envirement variable created by aws-vault need to be passed onto docker and then run the terraform cmd
```sh
aws-vault exec bigbaw -- docker run --rm -it \
        -e AWS_VAULT \
        -e AWS_ACCESS_KEY_ID  \
        -e AWS_SECRET_ACCESS_KEY  \
        -e AWS_SESSION_TOKEN  \
        -e AWS_SECURITY_TOKEN  \
        -e AWS_SESSION_EXPIRATION  \
        -e AWS_REGION \
        -v `pwd`:/root -w /root \
        -v ~/.kube:/root/.kube \
        -v ~/.aws:/root/.aws \
        alexiskats/aws-k8s "terraform init -backend=true -backend-config=env/dev/backend.tfvars"

aws-vault exec bigbaw -- docker run --rm -it \
        -e AWS_VAULT \
        -e AWS_ACCESS_KEY_ID  \
        -e AWS_SECRET_ACCESS_KEY  \
        -e AWS_SESSION_TOKEN  \
        -e AWS_SECURITY_TOKEN  \
        -e AWS_SESSION_EXPIRATION  \
        -e AWS_REGION \
        -v `pwd`:/root -w /root \
        -v ~/.kube:/root/.kube \
        -v ~/.aws:/root/.aws \
        alexiskats/aws-k8s "terraform apply -var-file=env/dev/terraform.tfvars"
```
--profile
aws-vault exec alexis-mng -- org-formation init organization.yml --region eu-west-1
aws-vault exec alexis-mng -- org-formation perform-tasks ./organization-tasks.yml --state-bucket-name organization-formation-339638031741 --state-object state.json
AWS_PROFILE=alexis-mng
aws-vault exec alexis-mng -- org-formation perform-tasks ./organization-tasks.yml

## Docker
### Running
```
docker ps
docker port flask-tutorial
docker run -d -p 5000:5000 flask-tutorial
```
### Clean up
```
docker image prune -a
docker container prune
docker rmi -f 270d5ba2c890
docker rmi $(docker images -a -q)
```
## AWS CLI
```
aws-vault exec bigbaw -- docker run --rm -it \
	-e AWS_ACCESS_KEY_ID  \
	-e AWS_SECRET_ACCESS_KEY  \
	-e AWS_SESSION_TOKEN  \
	-e AWS_REGION \
	amazon/aws-cli eks list-clusters
```

```
aws-vault exec alexis-mng -- docker run --rm -it \
	-e AWS_ACCESS_KEY_ID  \
	-e AWS_SECRET_ACCESS_KEY  \
	-e AWS_SESSION_TOKEN  \
	-e AWS_REGION \
	amazon/aws-cli sts get-caller-identity
```