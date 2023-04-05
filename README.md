# Improving the Code Reusability with Terraform Module

This is a presentation about my experience of implementing 'effective' automation with Terraform.

You can check out the contents below in `presentation.pdf`.

<br>

## Contents

**1. Terraform Basic Concept**

In this section, I'm gonna explain the definition of provisioning and IaC, known as Infrastrcture as Code.  
Then, let's find out what Terraform is, and how it works.

<br>

**2. Terraform Module**

I want to tell my experience why I studied and applied Terraform Module. You may figure it out if you compare the tree structure before, and after applying Terraform Module. Plus, we can configure a backend using S3 and DynamoDB.  
Let's see how Terraform manages its state files.

<br>

**3. Live Demo**

Demo is the best practice to understand all these concepts. Let's go on!

<br>
<br>

## Demo Tree Structure & Architecture
**In this Demo, you can configure dev and prod environment by reusing network and ec2 modules.**

- `network module` involves vpc, subnet, internet gateway, nat gateway, EIP, and route table  
- `ec2 module` involves key, bastion host, and private ec2 instances

<img alt="module tree structure" src="https://user-images.githubusercontent.com/70079416/230025387-f166db5f-0c01-4138-80f9-86c619376e02.png" width=50% height=50%>

<br>

### Now, let's go for it!

**This demo deploys EC2 instances on a single availability zone in the dev environment, and on multiple availability zones in the prod environment.**

- Don't forget to delete all these resources after running this demo❗️ It invloves some resources that are charged.
- What you should do is just changing the values of `dev.tfvars` and `prod.tfvars`. Resouce modules will be reused by calling them at the root module.

#### This is an architecture of this demo.
<img alt="architecture" src="https://user-images.githubusercontent.com/70079416/230025362-e9480b2a-48ed-4cba-ab26-652ddf98a267.png" width=80% height=80%>

<br>

## CLI Commands for Demo

Before running, you should install aws cli(v2) and terraform using homebrew.

- This is how you shorten the 'terraform' command to 'tf'.
  ```bash
  # path
  which terraform
  
  # inject path
  sudo ln ${path}/terraform ${path}/tf
  ```
- This demo calls key-pair resource using `data` block, which means key-pair is provisioned already on console.   
  So, if you want to run this demo,
    1. just create you key-pair on console directly
    2. and modify `key_name` info at the very top of the `modules/ec2/main.tf` file.    

<br>
<br>

#### 1. (if configuring the backend) First, provision S3 bucket and DynamoDB table in the `global` folder.

```bash
# terraform-demo/global
tf init
tf fmt # check and apply a canonical format
tf validate # verify if configuration files are valid
tf plan --var-file
```

#### 2. Provision the dev environment
 - But if you didn't configure the backend, please annotate the `terraform` block!

```bash
# terraform-demo/root/dev
tf init
tf fmt & tf validate # optional step
tf plan --var-file=dev.tfvars
tf apply --var-file=dev.tfvars -auto-approve
```

#### 3. Provision the prod environment. Just change the `.tfvars` file.

```bash
# terraform-demo/root/prod
tf init
tf fmt & tf validate # optional step
tf plan --var-file=prod.tfvars
tf apply --var-file=prod.tfvars -auto-approve
```

#### 4. Remove the resources you provisioned above.

```bash
# terraform-demo/root/dev
tf destroy -var-file=dev.tfvars

# terraform-demo/root/prod
tf destroy -var-file=prod.tfvars
```

<br>

## References

🖥️ Web : [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

📚 Book : Terraform Up&Running _by Oreilly_

🐹 Support & Advice : **AUSG 명예 안아줘요** 🌟
