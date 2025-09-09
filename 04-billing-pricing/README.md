# AWS Billing and Pricing

## 📋 Learning Objectives
By the end of this section, you should understand:
- AWS pricing models and cost factors
- Cost management tools and strategies
- AWS support plans and their features
- How to optimize costs effectively

---

## 💰 AWS Pricing Models

### 1. Pay-As-You-Go
**Concept**: Pay only for what you use, when you use it

**Benefits**:
- No upfront costs
- No long-term commitments
- Scale up or down as needed
- Focus on innovation, not procurement

**Examples**:
- EC2: Per second billing (minimum 60 seconds)
- S3: Per GB stored and requests made
- Lambda: Per request and compute time

### 2. Save When You Reserve
**Concept**: Reserve capacity and save up to 75% compared to On-Demand

**Reserved Instance Types**:
- **Standard RIs**: Up to 75% savings, can modify AZ, instance size
- **Convertible RIs**: Up to 54% savings, can change instance family
- **Scheduled RIs**: For predictable, recurring schedules

**Terms**: 1 year or 3 years
**Payment Options**: All Upfront, Partial Upfront, No Upfront

### 3. Pay Less by Using More
**Concept**: Volume-based discounts

**Examples**:
- **S3**: Cheaper per GB as usage increases
- **Data Transfer**: Tiered pricing
- **CloudFront**: Lower cost per GB at higher volumes

### 4. Benefit from AWS Customer Base
**Concept**: AWS passes savings from economies of scale to customers

**Examples**:
- Regular price reductions
- New lower-cost services
- Infrastructure improvements

---

## 🏷️ Pricing Factors

### Compute (EC2)
**Factors**:
- **Instance Type**: CPU, memory, storage, network performance
- **Region**: Prices vary by region
- **Operating System**: Linux, Windows, RHEL pricing differences
- **Tenancy**: Shared vs dedicated hardware

**Pricing Models**:
- **On-Demand**: Standard pay-per-use
- **Reserved Instances**: 1-3 year commitments
- **Spot Instances**: Bid for unused capacity (up to 90% savings)
- **Dedicated Hosts**: Physical servers for compliance

### Storage (S3)
**Factors**:
- **Storage Class**: Standard, IA, Glacier, etc.
- **Amount of Data**: Per GB pricing
- **Requests**: GET, PUT, DELETE operations
- **Data Transfer**: Out of AWS (in is free)

### Database (RDS)
**Factors**:
- **Instance Class**: CPU and memory
- **Database Engine**: MySQL, PostgreSQL, Oracle, SQL Server
- **Deployment**: Single-AZ vs Multi-AZ
- **Storage Type**: General Purpose, Provisioned IOPS

### Data Transfer
**Pricing Rules**:
- **Free**: Data transfer IN to AWS
- **Free**: Data transfer between services in same region
- **Charged**: Data transfer OUT of AWS
- **Charged**: Data transfer between regions

---

## 🛠️ Cost Management Tools

### AWS Cost Explorer
**What**: Visualize and manage AWS costs and usage

**Features**:
- Cost and usage reports
- Forecasting (up to 12 months)
- Reserved Instance recommendations
- Savings Plans recommendations

**Use Cases**:
- Identify cost trends
- Find cost optimization opportunities
- Track Reserved Instance utilization

### AWS Budgets
**What**: Set custom cost and usage budgets

**Budget Types**:
- **Cost Budgets**: Track costs against a dollar amount
- **Usage Budgets**: Track usage against service limits
- **Reservation Budgets**: Track RI and Savings Plans utilization
- **Savings Plans Budgets**: Track Savings Plans utilization

**Features**:
- Email and SNS alerts
- Multiple alert thresholds
- Integration with Cost Explorer

### AWS Cost and Usage Report
**What**: Most comprehensive cost and usage data

**Features**:
- Hourly, daily, or monthly reports
- Delivered to S3
- Integration with analytics tools
- Line-item details for all charges

### AWS Trusted Advisor
**What**: Real-time recommendations for cost optimization

**Cost Optimization Checks**:
- Underutilized EC2 instances
- Idle load balancers
- Unassociated Elastic IP addresses
- Low utilization Amazon RDS instances

**Availability**: Basic checks for all customers, full suite for Business/Enterprise support

---

## 📞 AWS Support Plans

### Basic Support (Free)
**Included**:
- Customer Service and Communities
- Documentation, whitepapers, support forums
- AWS Trusted Advisor (7 core checks)
- AWS Personal Health Dashboard

**Best For**: Experimentation and testing

### Developer Support ($29/month or 3% of usage)
**Includes Basic Support Plus**:
- Business hours email support
- General guidance (<24 hour response)
- System impaired (<12 hour response)
- 1 primary contact

**Best For**: Development and testing

### Business Support ($100/month or 10%-3% of usage)
**Includes Developer Support Plus**:
- 24/7 phone, email, and chat support
- Production system impaired (<4 hour response)
- Production system down (<1 hour response)
- Unlimited contacts
- Trusted Advisor full checks
- API support

**Best For**: Production workloads

### Enterprise Support ($15,000/month or 10%-3% of usage)
**Includes Business Support Plus**:
- Technical Account Manager (TAM)
- Business-critical system down (<15 minute response)
- Concierge Support Team
- Infrastructure Event Management
- Well-Architected Reviews

**Best For**: Mission-critical workloads

---

## 📊 Cost Optimization Strategies

### Right-Sizing
**Strategy**: Match instance types to workload requirements

**Actions**:
- Monitor CPU, memory, network utilization
- Downsize overprovisioned resources
- Use Auto Scaling for variable workloads

### Storage Optimization
**Strategy**: Choose appropriate storage classes

**Actions**:
- Use S3 Intelligent-Tiering
- Implement lifecycle policies
- Delete unnecessary snapshots and volumes

### Reserved Instances and Savings Plans
**Strategy**: Commit to usage for discounts

**Actions**:
- Analyze usage patterns
- Purchase RIs for steady-state workloads
- Use Savings Plans for flexibility

### Spot Instances
**Strategy**: Use spare capacity for fault-tolerant workloads

**Use Cases**:
- Batch processing
- Data analysis
- Testing environments
- CI/CD pipelines

### Auto Scaling
**Strategy**: Automatically adjust capacity

**Benefits**:
- Respond to demand changes
- Maintain performance
- Reduce over-provisioning

---

## 💳 Billing and Payment

### Consolidated Billing
**What**: Single payment method for multiple AWS accounts

**Benefits**:
- Single bill for all accounts
- Combined usage for volume discounts
- Easy tracking of costs per account
- No additional charges

### AWS Organizations
**What**: Centrally manage multiple AWS accounts

**Features**:
- Service Control Policies (SCPs)
- Consolidated billing
- Account creation and management
- Cost allocation tags

### Payment Methods
**Accepted**:
- Credit cards (Visa, MasterCard, American Express)
- Direct debit (in some countries)
- Wire transfer (for large amounts)

---

## 📈 Cost Allocation and Tagging

### Cost Allocation Tags
**Purpose**: Track costs by project, department, environment

**Tag Types**:
- **AWS-generated**: aws:createdBy, aws:cloudformation:stack-name
- **User-defined**: Project, Environment, Owner, Department

**Best Practices**:
- Establish tagging strategy early
- Use consistent tag names
- Automate tagging when possible
- Regularly review and cleanup tags

### Cost Categories
**What**: Group costs using rules and tags

**Use Cases**:
- Organize costs by business unit
- Track costs by application
- Allocate shared services costs

---

## 🎯 Common Pricing Scenarios

### Scenario 1: Web Application
**Architecture**: EC2 + RDS + S3 + CloudFront
**Cost Factors**:
- EC2 instance hours
- RDS instance hours and storage
- S3 storage and requests
- CloudFront data transfer

### Scenario 2: Data Backup
**Architecture**: On-premises → AWS Storage Gateway → S3 Glacier
**Cost Factors**:
- Storage Gateway usage
- Data transfer to AWS
- Glacier storage
- Retrieval costs

### Scenario 3: Development Environment
**Strategy**: Use Spot Instances, stop resources after hours
**Savings**: Up to 90% compared to On-Demand

---

## 📊 Free Tier Details

### Always Free Services
- **Lambda**: 1M requests/month
- **DynamoDB**: 25 GB storage
- **CloudWatch**: 10 custom metrics

### 12-Month Free Tier
- **EC2**: 750 hours t2.micro/month
- **S3**: 5 GB standard storage
- **RDS**: 750 hours db.t2.micro/month

### Trial Offers
- **Redshift**: 2-month trial
- **Inspector**: 90-day trial
- **QuickSight**: 30-day trial

---

## 🎯 Practice Questions Focus

**Key Topics for Exam**:
1. Understanding of different pricing models
2. When to use Reserved Instances vs Spot vs On-Demand
3. Support plan features and appropriate use cases
4. Cost optimization strategies
5. Free Tier limitations and offerings
6. Data transfer pricing (especially egress charges)

**Common Exam Scenarios**:
- Choosing most cost-effective option
- Identifying cost optimization opportunities
- Selecting appropriate support plan
- Understanding billing features

---

**Study Tip**: Focus on understanding cost optimization strategies and when to use different pricing models rather than memorizing exact prices, which change frequently.
