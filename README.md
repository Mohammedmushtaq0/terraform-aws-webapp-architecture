
# 🚀 Terraform AWS Scalable Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-v1.x-blueviolet?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![IaC](https://img.shields.io/badge/IaC-Infrastructure_as_Code-green)]()

A production-ready, scalable AWS infrastructure built with **Terraform**.  
It provisions VPC, EC2, Auto Scaling, ALB, RDS, S3, IAM, Route53, and CloudWatch monitoring.

---

## 🏗️ Architecture Overview

```mermaid
flowchart TD
  User([User]) --> DNS[Route53 DNS]
  DNS --> ALB[Application Load Balancer]
  ALB --> ASG[Auto Scaling Group]
  ASG --> EC2[EC2 Instances]
  EC2 --> RDS[(RDS Database)]
  EC2 --> S3[(S3 Storage)]
  CloudWatch[CloudWatch Monitoring] --> ALB
  CloudWatch --> ASG
````

---

## ⚡ Features

✅ Custom VPC with public/private subnets
✅ Auto Scaling EC2 instances behind ALB
✅ RDS for managed relational database
✅ S3 for object storage
✅ Route53 DNS and domain records
✅ IAM roles, groups, and policies
✅ CloudWatch monitoring & alarms

---

## 🛠️ Tech Stack

* **Terraform** (Infrastructure as Code)
* **AWS VPC, EC2, ALB, ASG**
* **AWS RDS & S3**
* **AWS IAM & Route53**
* **AWS CloudWatch**

---

## 📂 Project Structure

```
scalable-infra/
├── iamfiles/                  # IAM users, groups, policies
├── infrafiles/                # Core infra (VPC, EC2, RDS, S3, ALB, ASG, Route53)
├── metrics-monitoring-group/  # CloudWatch monitoring setup
├── outputfiles/               # Terraform outputs & endpoints
└── note.txt                   # Documentation notes
```

---

## 🚀 Getting Started

1. **Clone the repo**

   ```bash
   git clone https://github.com/your-username/terraform-aws-scalable-infra.git
   cd terraform-aws-scalable-infra/infrafiles
   ```

2. **Initialize Terraform**

   ```bash
   terraform init
   ```

3. **Preview changes**

   ```bash
   terraform plan
   ```

4. **Apply infrastructure**

   ```bash
   terraform apply
   ```

---

## 📌 Outputs

After deployment, you’ll get:

* ✅ ALB DNS Name
* ✅ RDS Endpoint
* ✅ S3 Bucket Name
* ✅ Public/Private Subnet IDs

---

## 🤝 Contributing

Contributions are welcome!
Please open an issue or submit a PR.

---

## 📜 License

This project is licensed under the **MIT License**.
