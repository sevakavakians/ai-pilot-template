# Monitoring & Observability

**Purpose**: Define monitoring strategies, alerting rules, and observability practices.  
**Audience**: DevOps engineers, SREs, on-call engineers  
**Update Frequency**: Monthly review, immediate for critical changes

## Monitoring Overview

### Three Pillars of Observability
1. **Metrics**: Quantitative measurements over time
2. **Logs**: Detailed event records
3. **Traces**: Request flow through systems

### Monitoring Stack
| Component | Tool | Purpose | Retention |
|-----------|------|---------|-----------|
| Metrics | Prometheus + Grafana | System & app metrics | 30 days |
| Logs | ELK Stack | Centralized logging | 14 days |
| Traces | Jaeger | Distributed tracing | 7 days |
| APM | Datadog | Application performance | 15 days |
| Uptime | Pingdom | External monitoring | 90 days |
| Errors | Sentry | Error tracking | 90 days |

## Key Metrics

### Golden Signals
```yaml
# The Four Golden Signals (Google SRE)
latency:
  description: Time to service a request
  target: p50 < 200ms, p95 < 500ms, p99 < 1s
  
traffic:
  description: Requests per second
  normal_range: 100-1000 RPS
  
errors:
  description: Rate of failed requests
  target: < 0.1%
  
saturation:
  description: Resource utilization
  targets:
    cpu: < 70%
    memory: < 80%
    disk: < 85%
```

### Application Metrics
```javascript
// Custom metrics collection
const promClient = require('prom-client');

// Counter - monotonically increasing value
const httpRequests = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status']
});

// Histogram - distribution of values
const httpDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.1, 0.5, 1, 2, 5]
});

// Gauge - value that can go up or down
const activeConnections = new promClient.Gauge({
  name: 'active_connections',
  help: 'Number of active connections'
});

// Summary - similar to histogram with quantiles
const requestSize = new promClient.Summary({
  name: 'http_request_size_bytes',
  help: 'Size of HTTP requests',
  percentiles: [0.5, 0.9, 0.99]
});

// Middleware to collect metrics
app.use((req, res, next) => {
  const end = httpDuration.startTimer();
  
  res.on('finish', () => {
    httpRequests.inc({
      method: req.method,
      route: req.route?.path || 'unknown',
      status: res.statusCode
    });
    
    end({ method: req.method, route: req.route?.path });
  });
  
  next();
});
```

### Infrastructure Metrics
| Metric | Warning | Critical | Action |
|--------|---------|----------|---------|
| CPU Usage | > 70% | > 90% | Scale horizontally |
| Memory Usage | > 75% | > 90% | Investigate leaks, scale |
| Disk Usage | > 70% | > 85% | Clean up, expand storage |
| Network I/O | > 80% | > 95% | Optimize, add capacity |
| Queue Depth | > 1000 | > 5000 | Scale consumers |
| Connection Pool | > 80% | > 95% | Increase pool size |

## Logging

### Log Levels & Guidelines
```javascript
// Logging configuration
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: 'api',
    environment: process.env.NODE_ENV,
    version: process.env.APP_VERSION
  },
  transports: [
    new winston.transports.Console({
      format: winston.format.simple()
    }),
    new winston.transports.File({
      filename: 'error.log',
      level: 'error'
    }),
    new winston.transports.File({
      filename: 'combined.log'
    })
  ]
});

// Log level guidelines
logger.error('Database connection failed', {
  error: err.message,
  stack: err.stack,
  attemptNumber: 3
}); // System failures, data loss risk

logger.warn('API rate limit approaching', {
  current: 950,
  limit: 1000,
  userId: user.id
}); // Potential issues, degraded performance

logger.info('User logged in', {
  userId: user.id,
  method: 'oauth',
  ip: req.ip
}); // Important business events

logger.debug('Cache miss', {
  key: cacheKey,
  ttl: 3600
}); // Detailed diagnostic info

logger.verbose('Request details', {
  headers: req.headers,
  body: req.body
}); // Very detailed information
```

### Structured Logging
```javascript
// Standardized log format
class StructuredLogger {
  log(level, message, context = {}) {
    const logEntry = {
      timestamp: new Date().toISOString(),
      level,
      message,
      ...context,
      
      // Request context
      requestId: context.req?.id,
      userId: context.req?.user?.id,
      sessionId: context.req?.session?.id,
      ip: context.req?.ip,
      userAgent: context.req?.get('user-agent'),
      
      // Application context
      service: process.env.SERVICE_NAME,
      version: process.env.APP_VERSION,
      environment: process.env.NODE_ENV,
      hostname: os.hostname(),
      
      // Error context
      error: context.error ? {
        message: context.error.message,
        stack: context.error.stack,
        code: context.error.code
      } : undefined
    };
    
    // Remove undefined fields
    Object.keys(logEntry).forEach(key => 
      logEntry[key] === undefined && delete logEntry[key]
    );
    
    console.log(JSON.stringify(logEntry));
  }
}
```

### Log Aggregation
```yaml
# Logstash configuration
input {
  beats {
    port => 5044
  }
  
  tcp {
    port => 5000
    codec => json
  }
}

filter {
  # Parse JSON logs
  json {
    source => "message"
  }
  
  # Add geographic data from IP
  geoip {
    source => "ip"
    target => "geoip"
  }
  
  # Parse user agent
  useragent {
    source => "userAgent"
    target => "ua"
  }
  
  # Add custom fields
  mutate {
    add_field => {
      "[@metadata][index_name]" => "%{service}-%{+YYYY.MM.dd}"
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "%{[@metadata][index_name]}"
  }
  
  # Send errors to dedicated index
  if [level] == "error" {
    elasticsearch {
      hosts => ["elasticsearch:9200"]
      index => "errors-%{+YYYY.MM.dd}"
    }
  }
}
```

## Distributed Tracing

### Trace Implementation
```javascript
// OpenTelemetry setup
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { registerInstrumentations } = require('@opentelemetry/instrumentation');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');

// Initialize tracer
const provider = new NodeTracerProvider({
  resource: new Resource({
    [SemanticResourceAttributes.SERVICE_NAME]: 'api-service',
    [SemanticResourceAttributes.SERVICE_VERSION]: '1.0.0',
  }),
});

// Configure span processor
provider.addSpanProcessor(
  new BatchSpanProcessor(
    new JaegerExporter({
      endpoint: 'http://jaeger:14268/api/traces',
    })
  )
);

// Register instrumentations
registerInstrumentations({
  instrumentations: [
    new HttpInstrumentation({
      requestHook: (span, request) => {
        span.setAttribute('http.request.body', JSON.stringify(request.body));
      },
    }),
    new ExpressInstrumentation(),
    new MongoDBInstrumentation(),
  ],
});

// Custom span creation
const tracer = trace.getTracer('api-service');

async function processOrder(orderId) {
  const span = tracer.startSpan('process-order', {
    attributes: {
      'order.id': orderId,
      'order.processing.start': Date.now()
    }
  });
  
  try {
    // Create child spans for sub-operations
    const validationSpan = tracer.startSpan('validate-order', {
      parent: span
    });
    await validateOrder(orderId);
    validationSpan.end();
    
    const paymentSpan = tracer.startSpan('process-payment', {
      parent: span
    });
    await processPayment(orderId);
    paymentSpan.end();
    
    span.setStatus({ code: SpanStatusCode.OK });
  } catch (error) {
    span.recordException(error);
    span.setStatus({
      code: SpanStatusCode.ERROR,
      message: error.message
    });
    throw error;
  } finally {
    span.end();
  }
}
```

## Alerting

### Alert Configuration
```yaml
# Prometheus alerting rules
groups:
  - name: application
    interval: 30s
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }} for {{ $labels.service }}"
          
      - alert: HighLatency
        expr: histogram_quantile(0.95, http_request_duration_seconds) > 1
        for: 10m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "High latency detected"
          description: "95th percentile latency is {{ $value }}s"
          
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
          team: oncall
        annotations:
          summary: "Service {{ $labels.service }} is down"
          description: "Service has been down for more than 1 minute"
```

### Alert Routing
```yaml
# Alertmanager configuration
global:
  resolve_timeout: 5m
  slack_api_url: 'YOUR_SLACK_WEBHOOK'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 5m
  repeat_interval: 12h
  receiver: 'default'
  
  routes:
    - match:
        severity: critical
      receiver: pagerduty
      continue: true
      
    - match:
        severity: warning
      receiver: slack
      
    - match:
        team: database
      receiver: dba-team

receivers:
  - name: default
    slack_configs:
      - channel: '#alerts'
        title: 'Alert: {{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
        
  - name: pagerduty
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_KEY'
        description: '{{ .GroupLabels.alertname }}'
        
  - name: dba-team
    email_configs:
      - to: 'dba-team@example.com'
        from: 'alerts@example.com'
```

### Alert Fatigue Prevention
```javascript
// Smart alerting with deduplication
class AlertManager {
  constructor() {
    this.recentAlerts = new Map();
    this.alertCounts = new Map();
  }

  shouldAlert(alert) {
    const key = `${alert.name}:${alert.resource}`;
    const now = Date.now();
    
    // Check if recently alerted
    const lastAlert = this.recentAlerts.get(key);
    if (lastAlert && now - lastAlert < 300000) { // 5 minutes
      return false;
    }
    
    // Check alert frequency
    const count = this.alertCounts.get(key) || 0;
    if (count > 10) {
      // Too many alerts, suppress
      return false;
    }
    
    // Update tracking
    this.recentAlerts.set(key, now);
    this.alertCounts.set(key, count + 1);
    
    // Reset counter after 1 hour
    setTimeout(() => {
      this.alertCounts.set(key, 0);
    }, 3600000);
    
    return true;
  }
}
```

## Dashboards

### Dashboard Design Principles
1. **Overview First**: High-level health at a glance
2. **Drill Down**: Detailed views for investigation
3. **Time Windows**: Consistent time ranges
4. **Color Coding**: Red (bad), Yellow (warning), Green (good)
5. **Annotations**: Mark deployments, incidents

### Key Dashboards
```javascript
// Dashboard configuration as code
const dashboards = {
  overview: {
    name: 'System Overview',
    refresh: '30s',
    panels: [
      {
        title: 'Request Rate',
        query: 'sum(rate(http_requests_total[5m]))',
        type: 'graph'
      },
      {
        title: 'Error Rate',
        query: 'sum(rate(http_requests_total{status=~"5.."}[5m]))',
        type: 'graph',
        thresholds: [
          { value: 0.01, color: 'yellow' },
          { value: 0.05, color: 'red' }
        ]
      },
      {
        title: 'Response Time',
        query: 'histogram_quantile(0.95, http_request_duration_seconds)',
        type: 'graph'
      },
      {
        title: 'Active Users',
        query: 'sum(active_users)',
        type: 'stat'
      }
    ]
  },
  
  infrastructure: {
    name: 'Infrastructure',
    panels: [
      {
        title: 'CPU Usage',
        query: '100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)',
        type: 'gauge'
      },
      {
        title: 'Memory Usage',
        query: '(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100',
        type: 'gauge'
      },
      {
        title: 'Disk Usage',
        query: '100 - ((node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100)',
        type: 'gauge'
      }
    ]
  }
};
```

## SLIs, SLOs, and SLAs

### Service Level Indicators (SLIs)
```yaml
slis:
  availability:
    description: Percentage of successful requests
    formula: (successful_requests / total_requests) * 100
    measurement_window: 5 minutes
    
  latency:
    description: 95th percentile response time
    formula: histogram_quantile(0.95, http_request_duration_seconds)
    measurement_window: 5 minutes
    
  quality:
    description: Percentage of requests without errors
    formula: (1 - (error_requests / total_requests)) * 100
    measurement_window: 5 minutes
```

### Service Level Objectives (SLOs)
```yaml
slos:
  - name: API Availability
    sli: availability
    target: 99.9%
    window: 30 days
    
  - name: API Latency
    sli: latency
    target: < 500ms
    window: 30 days
    
  - name: Data Quality
    sli: quality
    target: 99.95%
    window: 30 days
```

### Error Budget Monitoring
```javascript
// Error budget calculation
function calculateErrorBudget(slo, actual) {
  const target = slo.target;
  const budget = 100 - target;
  const consumed = Math.max(0, target - actual);
  const remaining = budget - consumed;
  
  return {
    total: budget,
    consumed: consumed,
    remaining: remaining,
    percentageUsed: (consumed / budget) * 100,
    daysRemaining: (remaining / budget) * 30
  };
}

// Alert on error budget burn rate
if (errorBudget.percentageUsed > 80) {
  alert('Error budget nearly exhausted', {
    slo: slo.name,
    budgetRemaining: `${errorBudget.remaining}%`,
    estimatedDaysRemaining: errorBudget.daysRemaining
  });
}
```

## On-Call Procedures

### On-Call Rotation
```yaml
rotation:
  schedule: weekly
  handoff_time: "Monday 09:00 UTC"
  participants:
    - primary: engineer1
      backup: engineer2
    - primary: engineer3
      backup: engineer4
      
escalation_policy:
  - level: 1
    wait: 5 minutes
    contact: primary_oncall
    
  - level: 2
    wait: 15 minutes
    contact: backup_oncall
    
  - level: 3
    wait: 30 minutes
    contact: team_lead
    
  - level: 4
    wait: 60 minutes
    contact: engineering_manager
```

### Incident Response
```markdown
## Incident Response Checklist

1. **Acknowledge** the alert within 5 minutes
2. **Assess** severity and impact
3. **Communicate** in #incidents channel
4. **Mitigate** immediate impact
5. **Investigate** root cause
6. **Resolve** the issue
7. **Monitor** for recurrence
8. **Document** in incident report
```

## Capacity Planning

### Resource Forecasting
```javascript
// Capacity prediction based on trends
function predictCapacity(metrics, growthRate, horizon) {
  const current = {
    cpu: metrics.cpu.current,
    memory: metrics.memory.current,
    storage: metrics.storage.current,
    requests: metrics.requests.current
  };
  
  const predicted = {};
  for (const [resource, value] of Object.entries(current)) {
    predicted[resource] = value * Math.pow(1 + growthRate, horizon / 30);
  }
  
  return {
    current,
    predicted,
    recommendations: generateRecommendations(predicted)
  };
}
```

---
*Last Updated: [Date]*  
*Monitoring Lead: [Name]*  
*On-Call Schedule: [Link]*