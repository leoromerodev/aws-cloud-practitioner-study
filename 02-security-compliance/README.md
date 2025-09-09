# Security and Compliance

## 📋 Learning Objectives
- Understand AWS shared responsibility model
- Learn about AWS Identity and Access Management (IAM)
- Explore AWS security services
- Understand compliance programs

## 🛡️ AWS Shared Responsibility Model

AWS and the customer share responsibility for security and compliance.

### AWS Responsibility: "Security OF the Cloud"
- Physical security of data centers
- Hardware and software infrastructure
- Network infrastructure
- Virtualization infrastructure
- Managed services (RDS, Lambda, etc.)

### Customer Responsibility: "Security IN the Cloud"
- Customer data
- Identity and access management
- Application-level security
- Operating system updates and security patches
- Network and firewall configuration
- Client-side data encryption

## 👤 AWS Identity and Access Management (IAM)

IAM enables you to manage access to AWS services and resources securely.

### Core Components:

#### Users
- Individual people or applications
- Have permanent long-term credentials
- Should follow principle of least privilege

#### Groups
- Collection of users
- Easier to manage permissions
- Users inherit permissions from groups

#### Roles
- Temporary credentials
- Can be assumed by users, applications, or services
- No permanent credentials
- More secure than access keys

#### Policies
- JSON documents defining permissions
- Can be attached to users, groups, or roles
- Two types:
  - **Identity-based**: Attached to identities
  - **Resource-based**: Attached to resources

### IAM Best Practices:
- Enable MFA (Multi-Factor Authentication)
- Use roles for applications running on EC2
- Follow principle of least privilege
- Regularly rotate credentials
- Use AWS managed policies when possible
- Create individual IAM users

## 🔐 AWS Security Services

### AWS Organizations
- Centrally manage and govern multiple AWS accounts
- Service Control Policies (SCPs)
- Consolidated billing

### AWS Control Tower
- Set up and govern secure, multi-account AWS environment
- Landing zone with pre-configured security and compliance

### Amazon Cognito
- User identity and data synchronization
- User pools and identity pools
- Social and enterprise identity federation

### AWS Directory Service
- Managed Microsoft Active Directory
- Simple AD and AD Connector

### AWS Single Sign-On (SSO)
- Centrally manage SSO access
- Multiple AWS accounts and business applications

### AWS Secrets Manager
- Securely store and manage secrets
- Automatic rotation of secrets

### AWS Systems Manager Parameter Store
- Secure, hierarchical storage for configuration data
- Built-in or custom KMS encryption

## 🔒 Data Protection Services

### AWS Key Management Service (KMS)
- Create and manage encryption keys
- Integrated with most AWS services
- Hardware Security Modules (HSMs)

### AWS CloudHSM
- Dedicated hardware security modules
- FIPS 140-2 Level 3 compliance

### Amazon Macie
- Data security and data privacy service
- Uses machine learning to discover sensitive data

### AWS Certificate Manager (ACM)
- Provision and manage SSL/TLS certificates
- Free certificates for AWS services

## 🚨 Monitoring and Compliance

### AWS CloudTrail
- Records API calls and activities
- Audit trail for compliance
- Stores logs in S3

### Amazon CloudWatch
- Monitoring and observability
- Metrics, logs, and alarms
- Application and infrastructure monitoring

### AWS Config
- Track resource configurations
- Compliance with desired configurations
- Configuration history and change notifications

### Amazon Inspector
- Automated security assessments
- Application vulnerabilities and deviations

### AWS Trusted Advisor
- Real-time guidance and recommendations
- Security, performance, cost optimization

### AWS Security Hub
- Central security findings aggregator
- Security posture dashboard
- Compliance status monitoring

## 📜 Compliance Programs

AWS supports numerous compliance programs:

### Industry Standards:
- **SOC 1, 2, 3**: Service Organization Control
- **PCI DSS**: Payment Card Industry Data Security Standard
- **ISO 27001**: International security management
- **FedRAMP**: Federal Risk and Authorization Management Program

### Regional Compliance:
- **GDPR**: General Data Protection Regulation (EU)
- **HIPAA**: Health Insurance Portability and Accountability Act (US)
- **FISMA**: Federal Information Security Management Act (US)

### AWS Compliance Resources:
- **AWS Artifact**: Central resource for compliance-related information
- **AWS Compliance Center**: Overview of AWS compliance
- **Customer Compliance Center**: Resources for customer compliance

## 🏗️ Network Security

### Amazon VPC (Virtual Private Cloud)
- Isolated network environment
- Public and private subnets
- Internet and NAT gateways

### Security Groups
- Virtual firewalls for EC2 instances
- Stateful rules
- Allow rules only (deny by default)

### Network Access Control Lists (NACLs)
- Subnet-level security
- Stateless rules
- Allow and deny rules

### AWS WAF (Web Application Firewall)
- Protect web applications from common attacks
- SQL injection, XSS protection
- Rate limiting and IP filtering

### AWS Shield
- DDoS protection service
- **Standard**: Automatic protection
- **Advanced**: Enhanced protection and support

## 📝 Key Security Principles

1. **Implement a strong identity foundation**
2. **Apply security at all layers**
3. **Enable traceability**
4. **Automate security best practices**
5. **Protect data in transit and at rest**
6. **Keep people away from data**
7. **Prepare for security events**

## 🎯 Practice Scenarios

### Scenario 1: IAM Setup
A company needs to set up AWS access for their development team of 10 people. What's the best approach?

### Scenario 2: Data Encryption
A healthcare company needs to store patient data in S3. What encryption options should they consider?

### Scenario 3: Compliance Audit
An organization needs to demonstrate compliance with SOC 2. Which AWS services would help?

*Solutions and more scenarios in the practice-exams folder*
