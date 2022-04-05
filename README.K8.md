# Introduction
This repo can be used to deploy a  ```hello world``` to AWS EKS using terraform.

aws eks describe-cluster --name CLUSTER-NAME --query cluster.resourcesVpcConfig.clusterSecurityGroupId
aws eks describe-cluster --name CLUSTER-NAME --query cluster.resourcesVpcConfig.securityGroupIds

## AWS EKS/K8s
### Connect kubeconfig to AWS EKS with aws-vault
Clean up and check you have everything setup
```
which aws-iam-authenticator
which aws-vault
```
Check to see if you can get an auth token from the eks-cluster with the aws-vault user
```
aws-vault exec AWS-VAULT-PROFILE -- aws-iam-authenticator token -i CLUSTER-NAME --forward-session-name
```
Get and new vertion of ```~/.kube/```
```
mv ~/.kube ~/.kube_backup
aws-vault exec AWS-VAULT-PROFILE -- aws eks update-kubeconfig --region AWS-REGION --name CLUSTER-NAME
```
Note: The ```aws eks update-kubeconfig``` dose not append. It creates a new ```~/.kube/config``` file

Edit ```~/.kube/config``` to used ```aws-vault``` and ```aws-iam-authenticator``` from:
```
kind: Config
preferences: {}
users:
- name: arn:aws:eks:AWS-REGION:123456789012:cluster/CLUSTER-NAME
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - AWS-REGION
      - eks
      - get-token
      - --cluster-name
      - CLUSTER-NAME
      command: aws
```
To:
```
kind: Config
preferences: {}
users:
- name: arn:aws:eks:AWS-REGION:123456789012:cluster/CLUSTER-NAME
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - -c
      - |
        Profile="AWS-VAULT-PROFILE"
        EksCluster="CLUSTER-NAME"
        AuthCmd="aws-iam-authenticator token -i $EksCluster --forward-session-name"
        if [ -z "$AWS_VAULT" ]
        then exec aws-vault exec $Profile -- $AuthCmd
        elif [ "$AWS_VAULT" = "$Profile" ]
        then exec $AuthCmd
        else
        >&2 echo "--> Currently in $AWS_VAULT account, but tried accessing cluster in $Profile"
        exit 1
        fi
      command: sh
      env: null
```
Test Connection
```
kubectl config view
kubectl get svc
kubectl -n kube-system describe configmap aws-auth
kubectl -n kube-system get configmap aws-auth -o yaml
```
### Setup RBAC to allow IAM role/User access to K8 Cluster
Error: "Your current user or role does not have access to Kubernetes objects on this EKS cluster"
Download the AWS provided ClusterRole and ClusterRoleBinding configuration ```curl -o eks-console-full-access.yaml https://amazon-eks.s3.us-west-2.amazonaws.com/docs/eks-console-full-access.yaml```
Create the role and bindings by applying them to the cluster ```kubectl apply -f eks-console-full-access.yaml```
```
kubectl get roles --all-namespaces
kubectl get clusterroles
kubectl get rolebindings --all-namespaces
kubectl get clusterrolebindings
```
Edit the aws-auth configuration ```kubectl edit configmap/aws-auth -n kube-system```
```
data:
  mapUsers: |
    - userarn: arn:aws:iam::123456789:user/AWS_VAULT_USER
      username: AWS_VAULT_USER
      groups:
        - system:masters
        - eks-console-dashboard-full-access-group
  mapRoles: |
    - rolearn: arn:aws:iam::123456789:role/AWS_ROLE_1
      username: AWS_ROLE_1:{{SessionName}}
      groups:
        - system:masters
        - eks-console-dashboard-full-access-group
```
NOTE:
1. Change SSO role from ```arn:aws:iam::123456:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_RANDOM_STRING``` to: ```arn:aws:iam::123456:role/AWSReservedSSO_RANDOM_STRING```
2. You can find the role ARN been used by SSO by copy and paste the ENV variables for the console found on the SSO login screen into the terminal and then call ```aws sts get-caller-identity```. The AWSReservedSSO_XXX is the SSO role you can copy and paste in the IAM -> Role to get the full details
### Links
[Change with ./kube/conf to work with aws-vault](https://github.com/99designs/aws-vault/issues/344) 
[IAM Role access to cluster](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html) 
[Create kubeconfig from EKS](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html) 
[EKS Security Group](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html) 
[EKS Pod Connectivity issues](https://aws.amazon.com/premiumsupport/knowledge-center/eks-pod-connections/) 
[Auth error to EKS](https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/)
[Error from server (NotFound): configmaps "aws-auth" not found](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html#aws-auth-configmap)
[StackOverflow aws eks and aws sso RBAC authentication problem](https://stackoverflow.com/questions/65660833/aws-eks-and-aws-sso-rbac-authentication-problem)