# Scaling Strategies & Guidelines

**Purpose**: Define scaling approaches, capacity planning, and performance optimization strategies.  
**Audience**: DevOps, SREs, Infrastructure team, architects  
**Update Frequency**: Quarterly review, after scaling events

## Scaling Overview

### Scaling Dimensions
| Dimension | Description | When to Use | Implementation |
|-----------|-------------|------------|----------------|
| **Horizontal** | Add more instances | High traffic, redundancy | Auto-scaling groups |
| **Vertical** | Increase instance size | Resource constraints | Instance type change |
| **Functional** | Separate by function | Service isolation | Microservices |
| **Geographic** | Multiple regions | Global users | Multi-region deploy |
| **Data** | Partition data | Large datasets | Sharding, partitioning |

### Current Capacity
| Component | Current | Peak Load | Max Capacity | Headroom |
|-----------|---------|-----------|--------------|----------|
| Web Servers | 4 instances | 80% CPU | 20 instances | 75% |
| API Servers | 6 instances | 70% CPU | 30 instances | 80% |
| Database | 1 primary, 2 replicas | 60% CPU | 5 replicas | 40% |
| Cache | 3 nodes | 50% memory | 10 nodes | 70% |
| Queue Workers | 10 workers | 1000 msg/s | 50 workers | 80% |

## Auto-Scaling Configuration

### Application Auto-Scaling
```yaml
# Kubernetes HPA Configuration
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-autoscaler
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 3
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: "1000"
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 30
      - type: Pods
        value: 10
        periodSeconds: 30
      selectPolicy: Max
```

### AWS Auto-Scaling
```terraform
# Terraform Auto-Scaling Configuration
resource "aws_autoscaling_group" "app" {
  name                = "app-asg"
  min_size            = 2
  max_size            = 20
  desired_capacity    = 4
  health_check_type   = "ELB"
  health_check_grace_period = 300
  
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  
  target_group_arns = [aws_lb_target_group.app.arn]
  
  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "target_tracking" {
  name                   = "target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

# Step Scaling Policy
resource "aws_autoscaling_policy" "step_scaling" {
  name                   = "step-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "StepScaling"
  adjustment_type        = "PercentChangeInCapacity"
  
  step_adjustment {
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
    scaling_adjustment          = 10
  }
  
  step_adjustment {
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20
    scaling_adjustment          = 20
  }
  
  step_adjustment {
    metric_interval_lower_bound = 20
    scaling_adjustment          = 30
  }
}
```

### Database Scaling

#### Read Replica Scaling
```javascript
// Dynamic read replica management
class DatabaseScaler {
  async scaleReadReplicas(metrics) {
    const { cpuUsage, readLatency, connections } = metrics;
    
    // Determine if scaling needed
    if (cpuUsage > 80 || readLatency > 100 || connections > 80) {
      await this.addReadReplica();
    } else if (cpuUsage < 20 && readLatency < 20 && connections < 20) {
      await this.removeReadReplica();
    }
  }
  
  async addReadReplica() {
    const params = {
      DBInstanceIdentifier: `replica-${Date.now()}`,
      SourceDBInstanceIdentifier: 'production-db',
      DBInstanceClass: 'db.r5.large',
      PubliclyAccessible: false
    };
    
    await rds.createDBInstanceReadReplica(params).promise();
    
    // Update connection pool
    await this.updateConnectionPool();
  }
  
  async removeReadReplica() {
    const replicas = await this.getReadReplicas();
    
    if (replicas.length > MIN_REPLICAS) {
      const oldest = replicas.sort((a, b) => 
        a.InstanceCreateTime - b.InstanceCreateTime
      )[0];
      
      await rds.deleteDBInstance({
        DBInstanceIdentifier: oldest.DBInstanceIdentifier,
        SkipFinalSnapshot: true
      }).promise();
    }
  }
}
```

#### Database Sharding
```javascript
// Sharding strategy implementation
class ShardManager {
  constructor() {
    this.shards = [
      { id: 0, range: [0, 999999], host: 'shard0.db.com' },
      { id: 1, range: [1000000, 1999999], host: 'shard1.db.com' },
      { id: 2, range: [2000000, 2999999], host: 'shard2.db.com' },
      { id: 3, range: [3000000, 3999999], host: 'shard3.db.com' }
    ];
  }
  
  getShardForUser(userId) {
    // Consistent hashing
    const hash = this.hashUserId(userId);
    const shardIndex = hash % this.shards.length;
    return this.shards[shardIndex];
  }
  
  async rebalanceShards() {
    // Move data between shards to balance load
    const metrics = await this.getShardMetrics();
    const overloaded = metrics.filter(m => m.load > 80);
    const underutilized = metrics.filter(m => m.load < 40);
    
    for (const source of overloaded) {
      const target = underutilized.shift();
      if (target) {
        await this.migrateData(source, target);
      }
    }
  }
  
  async addShard() {
    const newShard = {
      id: this.shards.length,
      range: this.calculateNewRange(),
      host: `shard${this.shards.length}.db.com`
    };
    
    // Provision new database
    await this.provisionDatabase(newShard);
    
    // Migrate data to new shard
    await this.rebalanceShards();
    
    this.shards.push(newShard);
  }
}
```

### Cache Scaling

#### Redis Cluster Scaling
```bash
#!/bin/bash
# redis-scaling.sh

# Add node to cluster
add_redis_node() {
  local NEW_NODE=$1
  
  # Start new Redis instance
  redis-server --port 7006 --cluster-enabled yes --cluster-config-file nodes-7006.conf
  
  # Add to cluster
  redis-cli --cluster add-node ${NEW_NODE}:7006 ${MASTER_NODE}:7000
  
  # Rebalance slots
  redis-cli --cluster rebalance ${MASTER_NODE}:7000
}

# Remove node from cluster
remove_redis_node() {
  local NODE_ID=$1
  
  # Migrate slots
  redis-cli --cluster reshard ${MASTER_NODE}:7000 \
    --cluster-from ${NODE_ID} \
    --cluster-to ${MASTER_ID} \
    --cluster-slots 4096
  
  # Remove node
  redis-cli --cluster del-node ${MASTER_NODE}:7000 ${NODE_ID}
}

# Monitor and auto-scale
monitor_and_scale() {
  while true; do
    MEMORY_USAGE=$(redis-cli INFO memory | grep used_memory_rss_human | cut -d: -f2)
    CPU_USAGE=$(redis-cli INFO cpu | grep used_cpu_sys | cut -d: -f2)
    
    if [[ ${MEMORY_USAGE} > "80%" ]]; then
      add_redis_node "new-node-${RANDOM}"
    fi
    
    sleep 60
  done
}
```

## Load Balancing

### Load Balancer Configuration
```nginx
# Nginx load balancing configuration
upstream backend {
    least_conn;  # Load balancing method
    
    # Health checks
    zone backend_zone 64k;
    
    # Servers with weights
    server backend1.example.com:8080 weight=5 max_fails=3 fail_timeout=30s;
    server backend2.example.com:8080 weight=3 max_fails=3 fail_timeout=30s;
    server backend3.example.com:8080 weight=2 max_fails=3 fail_timeout=30s;
    
    # Backup servers
    server backup1.example.com:8080 backup;
    server backup2.example.com:8080 backup;
    
    # Keep-alive connections
    keepalive 32;
    keepalive_requests 100;
    keepalive_timeout 60s;
}

server {
    listen 80;
    
    location / {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        
        # Load balancing headers
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 5s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Buffering
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
    }
    
    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
    }
}
```

### Application Load Balancer (ALB)
```terraform
resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = aws_subnet.public.*.id
  
  enable_deletion_protection = true
  enable_http2              = true
  enable_cross_zone_load_balancing = true
  
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }
  
  deregistration_delay = 30
  
  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }
}

resource "aws_lb_listener_rule" "weighted_routing" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100
  
  action {
    type = "forward"
    
    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = 80
      }
      
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = 20
      }
      
      stickiness {
        enabled  = true
        duration = 3600
      }
    }
  }
  
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
```

## Capacity Planning

### Growth Projections
```python
# capacity_planning.py
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression

def predict_capacity(historical_data, months_ahead=6):
    """Predict future capacity needs based on historical trends"""
    
    # Prepare data
    df = pd.DataFrame(historical_data)
    df['month'] = pd.to_datetime(df['date']).dt.month
    df['trend'] = range(len(df))
    
    # Train model
    X = df[['trend', 'month']]
    y = df['usage']
    
    model = LinearRegression()
    model.fit(X, y)
    
    # Predict future
    future_months = []
    for i in range(months_ahead):
        future_month = {
            'trend': len(df) + i,
            'month': ((df['month'].iloc[-1] + i) % 12) + 1
        }
        future_months.append(future_month)
    
    future_df = pd.DataFrame(future_months)
    predictions = model.predict(future_df)
    
    # Calculate required capacity
    peak_usage = predictions.max()
    safety_factor = 1.5  # 50% headroom
    required_capacity = peak_usage * safety_factor
    
    return {
        'current_capacity': historical_data[-1]['capacity'],
        'predicted_peak': peak_usage,
        'required_capacity': required_capacity,
        'scale_factor': required_capacity / historical_data[-1]['capacity']
    }

# Usage
historical = [
    {'date': '2024-01', 'usage': 1000, 'capacity': 2000},
    {'date': '2024-02', 'usage': 1200, 'capacity': 2000},
    {'date': '2024-03', 'usage': 1500, 'capacity': 2000},
]

prediction = predict_capacity(historical)
print(f"Need to scale by {prediction['scale_factor']:.2f}x in next 6 months")
```

### Resource Utilization Monitoring
```javascript
// Resource monitoring and alerting
class ResourceMonitor {
  async checkUtilization() {
    const metrics = {
      cpu: await this.getCPUUsage(),
      memory: await this.getMemoryUsage(),
      disk: await this.getDiskUsage(),
      network: await this.getNetworkUsage(),
      connections: await this.getConnectionCount()
    };
    
    const alerts = [];
    
    // Check against thresholds
    if (metrics.cpu > 80) {
      alerts.push({
        level: 'warning',
        message: `CPU usage at ${metrics.cpu}%`,
        action: 'Consider scaling horizontally'
      });
    }
    
    if (metrics.memory > 90) {
      alerts.push({
        level: 'critical',
        message: `Memory usage at ${metrics.memory}%`,
        action: 'Immediate scaling required'
      });
    }
    
    if (metrics.disk > 85) {
      alerts.push({
        level: 'warning',
        message: `Disk usage at ${metrics.disk}%`,
        action: 'Clean up or expand storage'
      });
    }
    
    return { metrics, alerts };
  }
  
  async autoScale(metrics) {
    // Automatic scaling decisions
    if (metrics.cpu > 90 || metrics.memory > 90) {
      await this.scaleOut();
    } else if (metrics.cpu < 20 && metrics.memory < 30) {
      await this.scaleIn();
    }
  }
}
```

## Performance Testing for Scale

### Load Testing Scripts
```javascript
// k6 load testing for scaling validation
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '5m', target: 100 },   // Warm up
    { duration: '10m', target: 500 },  // Normal load
    { duration: '10m', target: 1000 }, // Peak load
    { duration: '10m', target: 2000 }, // Stress test
    { duration: '5m', target: 0 },     // Cool down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests under 500ms
    http_req_failed: ['rate<0.1'],    // Error rate under 10%
  },
};

export default function () {
  const payload = JSON.stringify({
    username: `user${Math.random()}`,
    data: 'x'.repeat(1000) // 1KB payload
  });
  
  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };
  
  const response = http.post('https://api.example.com/data', payload, params);
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  sleep(1);
}
```

### Scaling Validation
```bash
#!/bin/bash
# validate-scaling.sh

# Test auto-scaling behavior
echo "Starting scaling validation..."

# 1. Generate load
echo "Generating load..."
k6 run load-test.js &
LOAD_PID=$!

# 2. Monitor scaling events
echo "Monitoring scaling events..."
watch_scaling() {
  local START_COUNT=$(kubectl get pods -l app=api -o json | jq '.items | length')
  
  while kill -0 $LOAD_PID 2>/dev/null; do
    CURRENT_COUNT=$(kubectl get pods -l app=api -o json | jq '.items | length')
    CPU_USAGE=$(kubectl top pods -l app=api --no-headers | awk '{sum+=$2} END {print sum/NR}')
    
    echo "$(date): Pods: $CURRENT_COUNT, Avg CPU: $CPU_USAGE"
    
    if [ $CURRENT_COUNT -gt $START_COUNT ]; then
      echo "✓ Scale-out detected: $START_COUNT → $CURRENT_COUNT"
    fi
    
    sleep 10
  done
}

watch_scaling

# 3. Verify scale-down
echo "Waiting for scale-down..."
sleep 300

FINAL_COUNT=$(kubectl get pods -l app=api -o json | jq '.items | length')
echo "Final pod count: $FINAL_COUNT"

# 4. Analyze results
echo "Analyzing scaling behavior..."
kubectl get hpa api-autoscaler --watch=false
```

## Cost Optimization

### Right-Sizing Recommendations
```python
# right_sizing.py
def analyze_instance_utilization(metrics_data):
    """Recommend optimal instance sizes based on utilization"""
    
    recommendations = []
    
    for instance in metrics_data:
        avg_cpu = instance['cpu_avg']
        max_cpu = instance['cpu_max']
        avg_mem = instance['memory_avg']
        max_mem = instance['memory_max']
        
        # Under-utilized (downsize)
        if max_cpu < 40 and max_mem < 40:
            recommendations.append({
                'instance': instance['id'],
                'current_type': instance['type'],
                'recommended_type': get_smaller_instance(instance['type']),
                'reason': 'Under-utilized',
                'savings': calculate_savings(instance['type'], 'smaller')
            })
        
        # Over-utilized (upsize)
        elif avg_cpu > 80 or avg_mem > 80:
            recommendations.append({
                'instance': instance['id'],
                'current_type': instance['type'],
                'recommended_type': get_larger_instance(instance['type']),
                'reason': 'Over-utilized',
                'cost_increase': calculate_cost_increase(instance['type'], 'larger')
            })
        
        # Optimal
        else:
            recommendations.append({
                'instance': instance['id'],
                'current_type': instance['type'],
                'recommended_type': instance['type'],
                'reason': 'Optimally sized'
            })
    
    return recommendations
```

### Spot Instance Strategy
```terraform
# Spot instance configuration for non-critical workloads
resource "aws_launch_template" "spot" {
  name_prefix   = "spot-instance-"
  image_id      = data.aws_ami.latest.id
  instance_type = "t3.medium"
  
  instance_market_options {
    market_type = "spot"
    
    spot_options {
      max_price          = "0.05"  # Maximum price willing to pay
      spot_instance_type = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Configure for stateless workloads
    echo "Spot instance started" > /var/log/spot-init.log
    
    # Register with job queue
    aws sqs send-message \
      --queue-url ${aws_sqs_queue.jobs.url} \
      --message-body "worker-ready"
    
    # Start worker process
    /usr/local/bin/worker --stateless --checkpoint-interval=60
  EOF
  )
}
```

---
*Last Updated: [Date]*  
*Scaling Lead: [Name]*  
*Capacity Planning: [Email]*