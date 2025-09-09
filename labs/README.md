# AWS Labs - Hands-On Practice

Welcome to the hands-on labs section! Here you'll find practical exercises using different programming languages and tools to interact with AWS services.

## 📁 Lab Structure

```
labs/
├── python/          # Python + boto3 examples
├── javascript/      # Node.js + AWS SDK v3 examples  
├── java/           # Java + AWS SDK v2 examples
├── powershell/     # PowerShell + AWS Tools examples
└── cli/            # AWS CLI scripts and examples
```

## 🚀 Prerequisites

Before starting the labs, ensure you have:

### 1. AWS Account
- Free tier account is sufficient for most labs
- Avoid unnecessary charges by following cleanup instructions

### 2. AWS CLI
```bash
# Install AWS CLI v2
# Windows: Download from AWS website
# macOS: brew install awscli
# Linux: curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

### 3. Configure AWS Credentials
```bash
aws configure
# Enter your Access Key ID
# Enter your Secret Access Key  
# Enter your default region (e.g., us-east-1)
# Enter default output format (json)
```

### 4. Language-Specific Setup

#### Python
```bash
pip install boto3
pip install botocore
```

#### Node.js
```bash
npm install @aws-sdk/client-s3
npm install @aws-sdk/client-ec2
npm install @aws-sdk/client-iam
```

#### Java
Add to your `pom.xml`:
```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>bom</artifactId>
    <version>2.20.0</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

#### PowerShell
```powershell
Install-Module -Name AWS.Tools.Installer
Install-AWSToolsModule AWS.Tools.EC2,AWS.Tools.S3
```

## 🧪 Lab Categories

### Basic Labs (Start Here)
1. **AWS CLI Basics** - Configure and use basic CLI commands
2. **S3 Operations** - Create buckets, upload/download files
3. **EC2 Instances** - Launch and manage virtual machines
4. **IAM Users & Policies** - Create users and manage permissions

### Intermediate Labs  
1. **VPC Networking** - Create custom networks
2. **Load Balancers** - Distribute traffic across instances
3. **Auto Scaling** - Automatically scale resources
4. **CloudWatch Monitoring** - Set up monitoring and alerts

### Advanced Labs
1. **Infrastructure as Code** - CloudFormation templates
2. **Serverless Applications** - Lambda functions and API Gateway
3. **Container Services** - ECS and Fargate
4. **Database Services** - RDS and DynamoDB

## ⚠️ Important Notes

### Cost Management
- Most labs use free tier eligible services
- Always clean up resources after labs
- Monitor your AWS bill regularly
- Set up billing alerts

### Security Best Practices
- Never commit AWS credentials to code
- Use IAM roles when possible
- Follow principle of least privilege
- Enable MFA on your AWS account

### Lab Completion
Each lab includes:
- 📖 **Theory**: Background information
- 🔧 **Setup**: Prerequisites and initial configuration  
- 👨‍💻 **Practice**: Step-by-step instructions
- 🧹 **Cleanup**: Remove resources to avoid charges
- 🎯 **Challenge**: Extension exercises

## 🎯 Getting Started

1. Choose your preferred programming language
2. Start with the basic labs in that language
3. Complete each lab section by section
4. Don't forget to clean up resources!
5. Try the same lab in different languages to compare

Ready to get hands-on with AWS? Pick a language folder and let's start coding! 🚀
