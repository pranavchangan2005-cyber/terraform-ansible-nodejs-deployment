# Automated Node.js Deployment on AWS EC2 Using Terraform and Ansible

## Project Overview

This project automates the deployment of a Node.js application on an AWS EC2 instance using **Terraform** for infrastructure provisioning and **Ansible** for configuration management and application deployment.

The objective is to demonstrate Infrastructure as Code (IaC), configuration management, and automated application deployment as part of DevOps practices.

## Architecture

```text
Developer
    |
    v
Terraform
    |
    +---- Create AWS Security Group
    |
    +---- Provision EC2 Instance
    |
    v
Ansible
    |
    +---- Connect to EC2 through SSH
    |
    +---- Install Node.js and npm
    |
    +---- Clone Node.js Application
    |
    +---- Install Dependencies
    |
    +---- Start Application
    |
    v
Node.js Application
    |
    v
Browser (Port 3000)
```

## Technologies Used

- **AWS EC2** — Cloud compute instance
- **AWS Security Groups** — Network access control
- **Terraform** — Infrastructure provisioning
- **Ansible** — Configuration management and deployment automation
- **Ubuntu Linux** — Operating system
- **Node.js** — JavaScript runtime
- **npm** — Package management
- **Git and GitHub** — Version control and project hosting

## Project Structure

```text
terraform-ansible/
├── main.tf
├── outputs.tf
├── playbook.yml
├── .terraform.lock.hcl
└── .gitignore
```

- `main.tf` — Defines AWS infrastructure and automated Ansible execution.
- `outputs.tf` — Displays the EC2 public IP and application URL.
- `playbook.yml` — Automates Node.js installation and application deployment.
- `.terraform.lock.hcl` — Locks Terraform provider versions for consistent deployments.
- `.gitignore` — Excludes sensitive files and local Terraform data.

## Prerequisites

Before running this project, ensure you have:

- An AWS account with permission to create EC2 instances and security groups.
- AWS CLI configured with valid credentials.
- Terraform installed.
- Ansible installed.
- An existing AWS EC2 key pair and its private key.
- Git installed.

## Deployment Steps

### 1. Clone the repository

```bash
git clone https://github.com/pranavchangan2005-cyber/terraform-ansible-nodejs-deployment.git
cd terraform-ansible-nodejs-deployment
```

### 2. Configure AWS credentials

Configure your AWS CLI credentials using a secure method:

```bash
aws configure
```

Verify your AWS identity:

```bash
aws sts get-caller-identity
```

### 3. Configure the SSH key

Ensure the private key configured in `main.tf` is available locally and matches the EC2 key pair.

Set appropriate permissions:

```bash
chmod 400 ansible-key.pem
```

**Security:** Never commit private keys, AWS credentials, Terraform state files, or secret variable files to GitHub.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Validate the configuration

```bash
terraform validate
```

### 6. Review the infrastructure plan

Replace the example CIDR with your own current public IP address followed by `/32`.

```bash
terraform plan -var="ssh_allowed_cidr=YOUR_PUBLIC_IP/32"
```

### 7. Provision the infrastructure and deploy the application

```bash
terraform apply -var="ssh_allowed_cidr=YOUR_PUBLIC_IP/32"
```

Review the proposed changes and type `yes` when prompted.

Terraform provisions the infrastructure and invokes Ansible to deploy the application.

### 8. Retrieve the application URL

```bash
terraform output application_url
```

Retrieve the EC2 public IP:

```bash
terraform output ec2_public_ip
```

Open the application URL in your browser.

## Network Configuration

| Port | Purpose | Access |
|---|---|---|
| 22 | SSH administration | Restricted to the configured public IP CIDR |
| 3000 | Node.js application | Public access, as configured in the security group |

For production deployments, restrict application access where appropriate and use HTTPS through a reverse proxy or load balancer.

## Verification

Check the Terraform outputs:

```bash
terraform output
```

Check that the application responds, replacing the IP with your EC2 public IP:

```bash
curl -i http://YOUR_EC2_PUBLIC_IP:3000
```

A successful HTTP response confirms that the application is reachable.

## Cleanup

To avoid ongoing AWS charges, remove the infrastructure when it is no longer required:

```bash
terraform destroy -var="ssh_allowed_cidr=YOUR_PUBLIC_IP/32"
```

Review the proposed resources and type `yes` to confirm.

**Warning:** This destroys the Terraform-managed infrastructure, including the EC2 instance. Back up anything you need before running this command.

## Key Learnings

- Provisioning AWS infrastructure using Terraform.
- Managing EC2 network access using security groups.
- Automating application deployment using Ansible.
- Connecting to cloud instances securely through SSH.
- Managing project versions using Git and GitHub.
- Applying Infrastructure as Code and configuration-management principles.

## Project Repository

GitHub: https://github.com/pranavchangan2005-cyber/terraform-ansible-nodejs-deployment

## Conclusion

This project demonstrates an automated DevOps workflow in which Terraform provisions AWS infrastructure and Ansible deploys a Node.js application. It reduces manual configuration, improves repeatability, and provides practical experience with cloud infrastructure automation.

