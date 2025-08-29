# Infrastructure Documentation

**Purpose**: Document cloud resources, DevOps practices, and infrastructure as code.  
**Audience**: DevOps engineers, SREs, infrastructure team  
**Update Frequency**: On infrastructure changes, monthly review

## Infrastructure Overview

### Cloud Provider
**Primary**: AWS  
**Regions**: us-east-1 (primary), us-west-2 (DR)  
**Account Structure**:
- Production: 123456789012
- Staging: 123456789013  
- Development: 123456789014

### High-Level Architecture
```
┌─────────────────────────────────────────────────────────┐
│                      CloudFlare CDN                      │
└─────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────┐
│                    Application Load Balancer              │
└─────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┴─────────────────────┐
        │                                           │
┌───────────────┐                          ┌───────────────┐
│   ECS Cluster  │                          │   ECS Cluster  │
│   (Zone A)     │                          │   (Zone B)     │
└───────────────┘                          └───────────────┘
        │                                           │
┌───────────────┐                          ┌───────────────┐
│   RDS Primary  │──────────────────────────│  RDS Replica  │
└───────────────┘                          └───────────────┘
```

## Network Architecture

### VPC Configuration
```yaml
VPC:
  CIDR: 10.0.0.0/16
  Subnets:
    Public:
      - Zone A: 10.0.1.0/24
      - Zone B: 10.0.2.0/24
    Private:
      - Zone A: 10.0.10.0/24
      - Zone B: 10.0.11.0/24
    Database:
      - Zone A: 10.0.20.0/24
      - Zone B: 10.0.21.0/24
```

### Security Groups
| Name | Purpose | Inbound Rules | Outbound Rules |
|------|---------|---------------|----------------|
| alb-sg | Load Balancer | 80/443 from 0.0.0.0/0 | All to app-sg |
| app-sg | Application | 8080 from alb-sg | 443 to 0.0.0.0/0, 5432 to db-sg |
| db-sg | Database | 5432 from app-sg | None |
| cache-sg | Redis | 6379 from app-sg | None |

### Network ACLs
```yaml
Public_Subnet_NACL:
  Inbound:
    - 100: HTTP (80) from 0.0.0.0/0
    - 110: HTTPS (443) from 0.0.0.0/0
    - 120: Ephemeral (1024-65535) from 10.0.0.0/16
  Outbound:
    - 100: All traffic to 0.0.0.0/0

Private_Subnet_NACL:
  Inbound:
    - 100: All from 10.0.0.0/16
  Outbound:
    - 100: HTTPS (443) to 0.0.0.0/0
    - 110: All to 10.0.0.0/16
```

## Compute Resources

### ECS Configuration
```yaml
Cluster:
  Name: production-cluster
  Capacity_Providers:
    - FARGATE
    - FARGATE_SPOT
  
Task_Definition:
  Family: app-task
  CPU: 1024  # 1 vCPU
  Memory: 2048  # 2 GB
  Container:
    Image: 123456789012.dkr.ecr.us-east-1.amazonaws.com/app:latest
    Port: 8080
    Environment:
      - NODE_ENV: production
      - DATABASE_URL: ${SECRET_DATABASE_URL}
    Health_Check:
      Command: ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
      Interval: 30
      Timeout: 5
      Retries: 3
      
Service:
  Name: app-service
  Desired_Count: 4
  Min_Healthy_Percent: 50
  Max_Percent: 200
  Auto_Scaling:
    Min: 2
    Max: 10
    Target_CPU: 70
    Target_Memory: 80
```

### Lambda Functions
| Function | Runtime | Memory | Timeout | Trigger | Purpose |
|----------|---------|--------|---------|---------|---------|
| image-processor | Node.js 18 | 1024 MB | 30s | S3 | Resize uploaded images |
| data-export | Python 3.11 | 3008 MB | 900s | EventBridge | Generate reports |
| webhook-handler | Node.js 18 | 512 MB | 30s | API Gateway | Process webhooks |
| cleanup-job | Python 3.11 | 256 MB | 60s | EventBridge | Delete old data |

## Storage Systems

### RDS Configuration
```yaml
Database:
  Engine: PostgreSQL 14.7
  Instance_Class: db.r6g.xlarge
  Storage:
    Type: gp3
    Size: 100 GB
    IOPS: 3000
    Throughput: 125 MB/s
  Multi_AZ: true
  Backup:
    Retention: 30 days
    Window: "03:00-04:00"
  Maintenance_Window: "sun:04:00-sun:05:00"
  
Read_Replicas:
  - Region: us-east-1
    Instance_Class: db.r6g.large
  - Region: us-west-2
    Instance_Class: db.r6g.large
```

### ElastiCache Configuration
```yaml
Redis_Cluster:
  Engine: Redis 7.0
  Node_Type: cache.r6g.large
  Nodes: 3
  Automatic_Failover: true
  Snapshot:
    Retention: 7 days
    Window: "03:00-05:00"
  Parameter_Group:
    maxmemory-policy: allkeys-lru
    timeout: 300
```

### S3 Buckets
| Bucket | Purpose | Versioning | Lifecycle | Encryption |
|--------|---------|------------|-----------|------------|
| app-uploads | User uploads | Enabled | 90d to IA, 365d delete | AES-256 |
| app-backups | Database backups | Enabled | 30d to Glacier | AES-256 |
| app-logs | Application logs | Disabled | 30d delete | AES-256 |
| app-static | Static assets | Enabled | - | AES-256 |

## Container Registry

### ECR Configuration
```yaml
Repository:
  Name: app
  Scan_On_Push: true
  Lifecycle_Policy:
    Rules:
      - Description: Keep last 10 images
        Selection:
          Tag_Status: any
          Count_Type: imageCountMoreThan
          Count_Number: 10
        Action: expire
```

## CI/CD Pipeline

### GitHub Actions Workflow
```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm test
      - run: npm run lint
      
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: aws-actions/configure-aws-credentials@v2
      - run: |
          docker build -t app .
          docker tag app:latest $ECR_REGISTRY/app:$GITHUB_SHA
          docker push $ECR_REGISTRY/app:$GITHUB_SHA
          
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/amazon-ecs-deploy-task-definition@v1
        with:
          cluster: production-cluster
          service: app-service
```

### Deployment Strategy
```yaml
Blue_Green_Deployment:
  Target_Group_1: Current (Blue)
  Target_Group_2: New (Green)
  Steps:
    1. Deploy to Green
    2. Run smoke tests
    3. Switch ALB to Green
    4. Monitor for 15 minutes
    5. Terminate Blue
  Rollback:
    - Switch ALB back to Blue
    - Terminate Green
```

## Monitoring & Observability

### CloudWatch Configuration
```yaml
Dashboards:
  - Name: application-overview
    Widgets:
      - API Response Time
      - Error Rate
      - Request Count
      - Database Connections
      - Cache Hit Rate
      
Alarms:
  - Name: high-error-rate
    Metric: ErrorRate
    Threshold: 5%
    Period: 5 minutes
    Action: SNS Topic
    
  - Name: high-latency
    Metric: TargetResponseTime
    Threshold: 1000ms
    Period: 5 minutes
    Action: SNS Topic
    
Log_Groups:
  - /aws/ecs/app: 30 days retention
  - /aws/lambda/functions: 14 days retention
  - /aws/rds/instance: 7 days retention
```

### X-Ray Tracing
```yaml
Sampling_Rules:
  - Name: BasicSampling
    Priority: 9000
    Rate: 0.1  # 10% of requests
    Reservoir: 5  # Minimum per second
    
Service_Map:
  - Frontend → API Gateway
  - API Gateway → ECS Service
  - ECS Service → RDS
  - ECS Service → ElastiCache
  - ECS Service → S3
```

## Security & Compliance

### IAM Roles
```yaml
ECS_Task_Role:
  Policies:
    - AmazonS3ReadOnlyAccess
    - SecretsManagerReadWrite
    - CloudWatchLogsFullAccess
  Custom_Policy:
    - s3:PutObject on app-uploads/*
    - rds:Describe*
    
Lambda_Execution_Role:
  Policies:
    - AWSLambdaBasicExecutionRole
    - AWSXRayDaemonWriteAccess
  Custom_Policy:
    - s3:GetObject on app-uploads/*
    - s3:PutObject on app-processed/*
```

### Secrets Management
```yaml
AWS_Secrets_Manager:
  Secrets:
    - production/database/credentials
    - production/api/stripe
    - production/api/sendgrid
  Rotation:
    Enabled: true
    Schedule: 30 days
    Lambda: arn:aws:lambda:region:account:function:rotate-secret
```

### Compliance Controls
| Control | Implementation | Verification |
|---------|---------------|--------------|
| Encryption at Rest | All storage encrypted | AWS Config Rules |
| Encryption in Transit | TLS 1.2+ enforced | Security Groups |
| Access Logging | CloudTrail enabled | Log analysis |
| MFA | Required for console | IAM policy |
| Backup | Automated daily | Backup vault |

## Disaster Recovery

### Backup Strategy
```yaml
RDS:
  Automated_Backups: 30 days
  Manual_Snapshots: Monthly, retained 1 year
  Cross_Region_Copy: us-west-2
  
S3:
  Cross_Region_Replication:
    Source: us-east-1
    Destination: us-west-2
    
Application_State:
  Export_Frequency: Daily
  Format: JSON
  Storage: S3 with versioning
```

### Recovery Procedures
| Scenario | RTO | RPO | Procedure |
|----------|-----|-----|-----------|
| Service Failure | 5 min | 0 | Auto-scaling replaces instance |
| AZ Failure | 10 min | 0 | Traffic shifts to other AZ |
| Region Failure | 1 hour | 15 min | Failover to DR region |
| Data Corruption | 4 hours | 1 hour | Restore from snapshot |

## Cost Optimization

### Reserved Instances
| Service | Type | Term | Instances | Savings |
|---------|------|------|-----------|---------|
| RDS | db.r6g.xlarge | 1 year | 2 | 40% |
| ElastiCache | cache.r6g.large | 1 year | 3 | 35% |
| EC2 | Compute Savings Plan | 1 year | $500/month | 30% |

### Auto-Scaling Policies
```yaml
Time_Based_Scaling:
  Business_Hours:
    Schedule: "0 9 * * MON-FRI"
    Min: 4
    Desired: 6
    Max: 10
  Off_Hours:
    Schedule: "0 18 * * MON-FRI"
    Min: 2
    Desired: 2
    Max: 4
    
Metric_Based_Scaling:
  CPU_Utilization:
    Target: 70%
    Scale_Out_Cooldown: 300s
    Scale_In_Cooldown: 300s
```

## Infrastructure as Code

### Terraform Modules
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  database_subnets = ["10.0.20.0/24", "10.0.21.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = false
  
  tags = {
    Environment = "production"
    Terraform = "true"
  }
}
```

### CloudFormation Stacks
| Stack | Resources | Dependencies | Update Frequency |
|-------|-----------|--------------|------------------|
| network-stack | VPC, Subnets, IGW, NAT | None | Rare |
| security-stack | Security Groups, NACLs | network-stack | Monthly |
| compute-stack | ECS, ALB, Auto Scaling | network, security | Weekly |
| data-stack | RDS, ElastiCache, S3 | network, security | Monthly |

## Maintenance Windows

### Scheduled Maintenance
| Service | Window | Frequency | Duration |
|---------|--------|-----------|----------|
| RDS | Sun 04:00-05:00 UTC | Weekly | 30 min |
| ElastiCache | Sun 05:00-06:00 UTC | Weekly | 20 min |
| ECS Deployment | Tue/Thu 14:00 UTC | Bi-weekly | 15 min |
| Security Patching | First Sun 02:00 UTC | Monthly | 2 hours |

## Runbook References

### Common Operations
- [Deploy New Version](./runbooks/deploy.md)
- [Scale Resources](./runbooks/scaling.md)
- [Database Failover](./runbooks/db-failover.md)
- [Incident Response](./runbooks/incident.md)
- [Backup Restoration](./runbooks/restore.md)

---
*Last Updated: [Date]*  
*Next Review: [Date]*  
*Infrastructure Owner: [Name]*