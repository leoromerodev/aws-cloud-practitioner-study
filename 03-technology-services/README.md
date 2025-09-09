# AWS Technology and Services

## 📋 Learning Objectives
By the end of this section, you should understand:
- Core AWS compute, storage, database, and networking services
- When to use each service and their key features
- How services integrate with each other
- AWS management and deployment services

---

## 💻 Compute Services

### Amazon EC2 (Elastic Compute Cloud)
**What**: Virtual servers in the cloud

**Key Features**:
- Multiple instance types for different workloads
- Auto Scaling for elasticity
- Pay-per-use pricing
- Choice of operating systems

**Use Cases**:
- Web applications
- Development environments
- High-performance computing
- Enterprise applications

**Instance Types**:
- **General Purpose**: T3, M5 (balanced compute, memory, networking)
- **Compute Optimized**: C5 (CPU-intensive applications)
- **Memory Optimized**: R5, X1 (in-memory databases)
- **Storage Optimized**: I3, D2 (high sequential read/write)

### AWS Lambda
**What**: Serverless compute service

**Key Features**:
- No server management
- Pay only when code runs
- Automatic scaling
- Event-driven execution

**Use Cases**:
- Real-time file processing
- Data transformation
- API backends
- IoT backends

### AWS Elastic Beanstalk
**What**: Platform-as-a-Service for deploying applications

**Key Features**:
- Easy application deployment
- Automatic capacity provisioning
- Health monitoring
- Version management

**Supported Platforms**: Java, .NET, PHP, Node.js, Python, Ruby, Go

---

## 💾 Storage Services

### Amazon S3 (Simple Storage Service)
**What**: Object storage service

**Key Features**:
- Virtually unlimited storage
- 99.999999999% (11 9's) durability
- Multiple storage classes
- Versioning and lifecycle management

**Storage Classes**:
- **Standard**: Frequently accessed data
- **Standard-IA**: Infrequently accessed data
- **One Zone-IA**: Non-critical, infrequently accessed data
- **Glacier**: Archive storage (minutes to hours retrieval)
- **Glacier Deep Archive**: Long-term archive (12+ hours retrieval)

### Amazon EBS (Elastic Block Store)
**What**: Block storage for EC2 instances

**Key Features**:
- High availability and durability
- Encryption at rest and in transit
- Multiple volume types
- Snapshot backup

**Volume Types**:
- **gp3/gp2**: General Purpose SSD
- **io2/io1**: Provisioned IOPS SSD
- **st1**: Throughput Optimized HDD
- **sc1**: Cold HDD

### Amazon EFS (Elastic File System)
**What**: Fully managed NFS file system

**Key Features**:
- Shared storage across multiple EC2 instances
- Automatic scaling
- POSIX-compliant
- Regional service

---

## 🗄️ Database Services

### Amazon RDS (Relational Database Service)
**What**: Managed relational database service

**Supported Engines**:
- MySQL, PostgreSQL, MariaDB
- Oracle, SQL Server
- Amazon Aurora

**Key Features**:
- Automated backups
- Multi-AZ deployments
- Read replicas
- Automatic software patching

### Amazon DynamoDB
**What**: Fully managed NoSQL database

**Key Features**:
- Single-digit millisecond latency
- Automatic scaling
- Global tables
- Built-in security

**Use Cases**:
- Mobile applications
- Gaming
- IoT
- Real-time personalization

### Amazon Redshift
**What**: Data warehouse service

**Key Features**:
- Petabyte-scale data warehouse
- Columnar storage
- Parallel processing
- SQL-based queries

---

## 🌐 Networking Services

### Amazon VPC (Virtual Private Cloud)
**What**: Isolated virtual network in AWS

**Components**:
- **Subnets**: Public and private network segments
- **Internet Gateway**: Connect to internet
- **NAT Gateway**: Outbound internet access for private subnets
- **Route Tables**: Define traffic routing
- **Security Groups**: Instance-level firewalls
- **NACLs**: Subnet-level firewalls

### Amazon CloudFront
**What**: Content Delivery Network (CDN)

**Key Features**:
- Global edge locations
- Low latency content delivery
- DDoS protection
- Integration with other AWS services

### Amazon Route 53
**What**: Scalable DNS web service

**Key Features**:
- Domain registration
- DNS routing
- Health checking
- Traffic flow management

**Routing Policies**:
- Simple, Weighted, Latency-based
- Failover, Geolocation, Geoproximity

---

## 🛡️ Security Services

### AWS IAM (Identity and Access Management)
**What**: Manage access to AWS services

**Components**:
- **Users**: Individual people or applications
- **Groups**: Collections of users
- **Roles**: Temporary credentials
- **Policies**: Permissions in JSON format

### AWS KMS (Key Management Service)
**What**: Managed encryption key service

**Key Features**:
- Create and manage encryption keys
- Integration with AWS services
- Hardware Security Modules (HSMs)
- Audit trail of key usage

---

## 📊 Monitoring and Management

### Amazon CloudWatch
**What**: Monitoring and observability service

**Key Features**:
- Metrics collection and monitoring
- Alarms and notifications
- Logs management
- Application insights

**Use Cases**:
- Infrastructure monitoring
- Application performance monitoring
- Log analysis
- Cost optimization

### AWS CloudTrail
**What**: API logging service

**Key Features**:
- Record API calls
- Audit trail for compliance
- Integration with CloudWatch
- Data event logging

### AWS Config
**What**: Configuration management and compliance

**Key Features**:
- Track resource configurations
- Compliance monitoring
- Change notifications
- Remediation actions

---

## 🚀 Application Services

### Amazon SNS (Simple Notification Service)
**What**: Messaging service

**Key Features**:
- Pub/sub messaging
- Multiple delivery protocols
- Fan-out messaging
- Mobile push notifications

### Amazon SQS (Simple Queue Service)
**What**: Message queuing service

**Key Features**:
- Fully managed message queues
- Standard and FIFO queues
- Dead letter queues
- Visibility timeout

### AWS API Gateway
**What**: Managed API service

**Key Features**:
- REST and WebSocket APIs
- Request/response transformation
- API versioning and staging
- Throttling and caching

---

## 🔧 Developer Tools

### AWS CloudFormation
**What**: Infrastructure as Code service

**Key Features**:
- Template-based provisioning
- Stack management
- Change sets
- Cross-region deployment

### AWS CodeCommit
**What**: Managed Git repositories

### AWS CodeBuild
**What**: Continuous integration service

### AWS CodeDeploy
**What**: Automated deployment service

### AWS CodePipeline
**What**: Continuous delivery service

---

## 🎯 Service Selection Guidelines

### Compute Service Selection
```
Need full control? → EC2
Event-driven, short tasks? → Lambda
Easy deployment? → Elastic Beanstalk
Containerized apps? → ECS/Fargate
```

### Storage Service Selection
```
Object storage? → S3
Block storage for EC2? → EBS
Shared file system? → EFS
Archive storage? → Glacier
```

### Database Service Selection
```
Relational database? → RDS
NoSQL with high performance? → DynamoDB
Data warehouse? → Redshift
In-memory caching? → ElastiCache
```

### Networking Service Selection
```
Isolated network? → VPC
Content delivery? → CloudFront
DNS management? → Route 53
Load balancing? → ELB
```

---

## 🏗️ Common Architecture Patterns

### 3-Tier Web Application
```
Users → CloudFront → ELB → EC2 (Web/App) → RDS (Database)
                           ↓
                        S3 (Static Assets)
```

### Serverless Architecture
```
Users → API Gateway → Lambda → DynamoDB
                   ↓
               S3 (Storage)
```

### Microservices Architecture
```
Users → ALB → ECS/Fargate Services → RDS/DynamoDB
              ↓
          Service Discovery
```

---

## 📝 Key Service Characteristics to Remember

### Regional vs Global Services

**Global Services**:
- IAM, Route 53, CloudFront
- WAF, Shield

**Regional Services**:
- EC2, S3, RDS, VPC
- Lambda, DynamoDB

### Managed vs Unmanaged Services

**Fully Managed**:
- RDS, DynamoDB, Lambda
- S3, CloudFront, Route 53

**Customer Managed**:
- EC2 (OS, applications)
- Self-hosted databases on EC2

---

## 🎯 Practice Scenarios

### Scenario 1: E-commerce Website
**Requirements**: High availability, global users, seasonal traffic spikes
**Recommended Services**: EC2 + Auto Scaling, RDS Multi-AZ, CloudFront, S3

### Scenario 2: Data Analytics Platform
**Requirements**: Process large datasets, SQL queries, cost-effective
**Recommended Services**: Redshift, S3, Lambda, Athena

### Scenario 3: Mobile Application Backend
**Requirements**: Fast response times, push notifications, user authentication
**Recommended Services**: API Gateway, Lambda, DynamoDB, SNS, Cognito

---

**Study Tip**: Focus on understanding WHEN to use each service rather than memorizing all technical details. The exam tests your ability to recommend appropriate services for given scenarios.
