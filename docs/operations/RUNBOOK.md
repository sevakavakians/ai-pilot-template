# Operational Runbook

**Purpose**: Provide step-by-step procedures for common operational tasks and incident response.  
**Audience**: On-call engineers, DevOps team, SREs  
**Update Frequency**: After each incident, quarterly review

## Quick Reference

### Emergency Contacts
| Role | Name | Phone | Email | Slack |
|------|------|-------|-------|-------|
| On-Call Primary | Rotation | See PagerDuty | oncall@example.com | @oncall |
| On-Call Backup | Rotation | See PagerDuty | backup@example.com | @backup |
| Team Lead | John Doe | +1-XXX-XXX-XXXX | john@example.com | @john |
| DevOps Lead | Jane Smith | +1-XXX-XXX-XXXX | jane@example.com | @jane |
| Security Team | Security | +1-XXX-XXX-XXXX | security@example.com | @security |

### Critical Resources
| Resource | URL | Credentials |
|----------|-----|-------------|
| Production Dashboard | https://grafana.example.com | SSO |
| AWS Console | https://console.aws.amazon.com | MFA Required |
| PagerDuty | https://example.pagerduty.com | SSO |
| Status Page | https://status.example.com | Admin panel |
| Runbook Wiki | https://wiki.example.com/runbook | SSO |

## Common Procedures

### Service Restart

#### Application Service
```bash
# 1. Check current status
kubectl get pods -n production | grep app

# 2. Graceful restart
kubectl rollout restart deployment/app -n production

# 3. Monitor rollout
kubectl rollout status deployment/app -n production

# 4. Verify health
curl https://api.example.com/health

# 5. Check logs
kubectl logs -f deployment/app -n production --tail=100
```

#### Database Restart
```bash
# WARNING: Coordinate with team before database restart

# 1. Announce maintenance
./scripts/announce-maintenance.sh "Database restart in 5 minutes"

# 2. Stop application traffic
kubectl scale deployment/app --replicas=0 -n production

# 3. Restart database
aws rds reboot-db-instance --db-instance-identifier prod-db

# 4. Wait for database
aws rds wait db-instance-available --db-instance-identifier prod-db

# 5. Verify connectivity
psql -h prod-db.xxx.rds.amazonaws.com -U admin -c "SELECT 1"

# 6. Restore application
kubectl scale deployment/app --replicas=4 -n production
```

### Scaling Operations

#### Horizontal Scaling
```bash
# Auto-scaling adjustment
kubectl autoscale deployment app \
  --cpu-percent=70 \
  --min=2 \
  --max=10 \
  -n production

# Manual scaling
kubectl scale deployment/app --replicas=8 -n production

# Verify scaling
kubectl get hpa -n production
watch kubectl get pods -n production
```

#### Vertical Scaling
```yaml
# Edit deployment resources
kubectl edit deployment/app -n production

# Update resources section:
resources:
  requests:
    memory: "512Mi"
    cpu: "500m"
  limits:
    memory: "1Gi"
    cpu: "1000m"
```

### Cache Operations

#### Clear Redis Cache
```bash
# Connect to Redis
redis-cli -h redis.example.com -p 6379

# Clear specific pattern
redis-cli --scan --pattern "user:*" | xargs redis-cli DEL

# Clear all cache (CAUTION)
redis-cli FLUSHDB

# Verify
redis-cli INFO stats
```

#### Warm Cache
```bash
# Run cache warming script
./scripts/warm-cache.sh --type=product --parallel=4

# Monitor progress
tail -f logs/cache-warming.log

# Verify cache hit rate
redis-cli INFO stats | grep hit_rate
```

## Incident Response

### High Error Rate

#### Diagnosis Steps
1. **Check Dashboard**
```bash
# View error metrics
curl -s https://metrics.example.com/api/errors | jq .

# Check recent deployments
kubectl rollout history deployment/app -n production

# View error logs
kubectl logs -n production -l app=api --tail=1000 | grep ERROR
```

2. **Identify Pattern**
```bash
# Group errors by type
kubectl logs -n production -l app=api --since=1h | \
  grep ERROR | \
  awk '{print $5}' | \
  sort | uniq -c | sort -rn

# Check specific endpoints
grep "POST /api/checkout" /var/log/nginx/access.log | \
  awk '{print $9}' | sort | uniq -c
```

3. **Immediate Mitigation**
```bash
# Rollback if recent deployment
kubectl rollout undo deployment/app -n production

# Enable circuit breaker
curl -X POST https://api.example.com/admin/circuit-breaker/enable

# Increase rate limiting
kubectl set env deployment/app RATE_LIMIT=100 -n production
```

### High Latency

#### Quick Checks
```sql
-- Check slow queries
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
WHERE mean_exec_time > 1000
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Check locks
SELECT pid, usename, query, state, wait_event_type, wait_event
FROM pg_stat_activity
WHERE wait_event IS NOT NULL;

-- Kill long-running queries
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'active'
  AND now() - pg_stat_activity.query_start > interval '5 minutes';
```

#### Resolution Steps
```bash
# 1. Scale up instances
kubectl scale deployment/app --replicas=10 -n production

# 2. Increase connection pool
kubectl set env deployment/app DB_POOL_SIZE=50 -n production

# 3. Enable read replicas
kubectl set env deployment/app READ_REPLICA_ENABLED=true -n production

# 4. Clear problematic cache entries
redis-cli --scan --pattern "slow:*" | xargs redis-cli DEL
```

### Service Outage

#### Initial Response
```bash
#!/bin/bash
# outage-response.sh

# 1. Update status page
curl -X POST https://api.statuspage.io/v1/incidents \
  -H "Authorization: OAuth $STATUS_PAGE_TOKEN" \
  -d '{"incident": {"name": "Service Outage", "status": "investigating"}}'

# 2. Check all services
for service in api web database cache queue; do
  echo "Checking $service..."
  kubectl get pods -n production -l app=$service
done

# 3. Check external dependencies
for endpoint in payment-gateway auth-service cdn; do
  echo "Checking $endpoint..."
  curl -I https://$endpoint.example.com/health
done

# 4. Enable maintenance mode
kubectl set env deployment/app MAINTENANCE_MODE=true -n production
```

#### Recovery Steps
```bash
# 1. Identify root cause
./scripts/diagnose-outage.sh

# 2. Fix identified issues
# (Specific to root cause)

# 3. Gradual recovery
kubectl scale deployment/app --replicas=1 -n production
sleep 60
kubectl scale deployment/app --replicas=2 -n production
sleep 60
kubectl scale deployment/app --replicas=4 -n production

# 4. Verify recovery
./scripts/health-check-all.sh

# 5. Disable maintenance mode
kubectl set env deployment/app MAINTENANCE_MODE=false -n production

# 6. Update status page
curl -X PATCH https://api.statuspage.io/v1/incidents/$INCIDENT_ID \
  -d '{"incident": {"status": "resolved"}}'
```

### Database Issues

#### Connection Pool Exhaustion
```bash
# Check connection count
psql -c "SELECT count(*) FROM pg_stat_activity;"

# View connections by state
psql -c "SELECT state, count(*) FROM pg_stat_activity GROUP BY state;"

# Kill idle connections
psql -c "SELECT pg_terminate_backend(pid) 
         FROM pg_stat_activity 
         WHERE state = 'idle' 
         AND state_change < now() - interval '10 minutes';"

# Increase connection limit (temporary)
psql -c "ALTER SYSTEM SET max_connections = 500;"
psql -c "SELECT pg_reload_conf();"
```

#### Replication Lag
```sql
-- Check replication status
SELECT client_addr, state, sent_lsn, write_lsn, flush_lsn, replay_lsn,
       sent_lsn - replay_lsn AS lag_bytes
FROM pg_stat_replication;

-- On replica: check lag in seconds
SELECT EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp())) AS lag_seconds;

-- Identify blocking queries on primary
SELECT pid, usename, query, state
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY backend_start;
```

### Security Incidents

#### Suspected Breach
```bash
#!/bin/bash
# IMMEDIATE ACTIONS - RUN ALL COMMANDS

# 1. Isolate affected systems
kubectl cordon node-1 node-2  # Prevent new pods
kubectl label nodes node-1 node-2 quarantine=true

# 2. Preserve evidence
kubectl logs -n production --all-containers=true > /tmp/incident-logs.txt
kubectl get events -n production > /tmp/incident-events.txt

# 3. Rotate credentials
./scripts/rotate-all-secrets.sh --emergency

# 4. Enable enhanced logging
kubectl set env deployment/app LOG_LEVEL=DEBUG AUDIT_MODE=true -n production

# 5. Notify security team
./scripts/notify-security.sh "Suspected breach - immediate response required"
```

#### DDoS Attack
```bash
# 1. Enable DDoS protection
aws shield associate-drt-role --role-arn arn:aws:iam::xxx:role/DDoSResponse

# 2. Update WAF rules
aws wafv2 update-web-acl --scope CLOUDFRONT --id xxx \
  --lock-token xxx --rules file://emergency-rules.json

# 3. Enable rate limiting
kubectl set env deployment/app \
  RATE_LIMIT_ENABLED=true \
  RATE_LIMIT_REQUESTS=10 \
  RATE_LIMIT_WINDOW=60 \
  -n production

# 4. Scale up capacity
kubectl scale deployment/app --replicas=20 -n production

# 5. Enable Cloudflare "Under Attack" mode
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/settings/security_level" \
  -H "X-Auth-Key: $CF_AUTH_KEY" \
  -d '{"value": "under_attack"}'
```

## Maintenance Tasks

### Certificate Renewal
```bash
# Check certificate expiry
echo | openssl s_client -connect example.com:443 2>/dev/null | \
  openssl x509 -noout -dates

# Renew with Let's Encrypt
certbot renew --nginx

# Verify renewal
certbot certificates

# Reload nginx
nginx -s reload
```

### Backup Verification
```bash
#!/bin/bash
# verify-backup.sh

# 1. List recent backups
aws s3 ls s3://backup-bucket/database/ --recursive | tail -20

# 2. Download latest backup
LATEST_BACKUP=$(aws s3 ls s3://backup-bucket/database/ | tail -1 | awk '{print $4}')
aws s3 cp s3://backup-bucket/database/$LATEST_BACKUP /tmp/

# 3. Verify backup integrity
pg_restore --list /tmp/$LATEST_BACKUP > /dev/null
if [ $? -eq 0 ]; then
  echo "Backup is valid"
else
  echo "ALERT: Backup corruption detected!"
  ./scripts/alert-team.sh "Backup verification failed"
fi

# 4. Test restoration (on test instance)
pg_restore -h test-db.example.com -d test_restore /tmp/$LATEST_BACKUP
```

### Log Rotation
```bash
# Manual log rotation
logrotate -f /etc/logrotate.d/application

# Compress old logs
find /var/log/app -name "*.log" -mtime +7 -exec gzip {} \;

# Archive to S3
aws s3 sync /var/log/app/archive s3://logs-bucket/archive/ --delete

# Clean up old logs
find /var/log/app -name "*.gz" -mtime +30 -delete
```

## Disaster Recovery

### Regional Failover
```bash
#!/bin/bash
# regional-failover.sh

CONFIRM="no"
read -p "Confirm failover to DR region? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Failover cancelled"
  exit 1
fi

# 1. Update DNS to DR region
aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch file://dr-dns-update.json

# 2. Scale DR region
aws ecs update-service --cluster dr-cluster --service app \
  --desired-count 10 --region us-west-2

# 3. Verify DR health
for i in {1..10}; do
  if curl -f https://dr.example.com/health; then
    echo "DR region healthy"
    break
  fi
  sleep 30
done

# 4. Stop primary region (after confirmation)
read -p "Stop primary region? (yes/no): " STOP_PRIMARY
if [ "$STOP_PRIMARY" == "yes" ]; then
  aws ecs update-service --cluster prod-cluster --service app \
    --desired-count 0 --region us-east-1
fi
```

### Data Recovery
```bash
#!/bin/bash
# data-recovery.sh

# 1. Identify recovery point
echo "Available recovery points:"
aws rds describe-db-snapshots --db-instance-identifier prod-db \
  --query 'DBSnapshots[*].[DBSnapshotIdentifier,SnapshotCreateTime]' \
  --output table

read -p "Enter snapshot ID to restore: " SNAPSHOT_ID

# 2. Restore database
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier prod-db-recovered \
  --db-snapshot-identifier $SNAPSHOT_ID

# 3. Wait for restoration
aws rds wait db-instance-available \
  --db-instance-identifier prod-db-recovered

# 4. Verify data
psql -h prod-db-recovered.xxx.rds.amazonaws.com \
  -c "SELECT COUNT(*) FROM users;"

# 5. Switch application to recovered database
kubectl set env deployment/app \
  DATABASE_HOST=prod-db-recovered.xxx.rds.amazonaws.com \
  -n production
```

## Troubleshooting Guide

### Common Issues

#### Pod CrashLoopBackOff
```bash
# Get pod details
kubectl describe pod $POD_NAME -n production

# Check logs
kubectl logs $POD_NAME -n production --previous

# Common fixes:
# 1. Check resource limits
kubectl top pod $POD_NAME -n production

# 2. Verify secrets/configmaps
kubectl get secrets -n production
kubectl get configmaps -n production

# 3. Check liveness/readiness probes
kubectl get pod $POD_NAME -n production -o yaml | grep -A5 probe
```

#### Memory Leaks
```bash
# Monitor memory usage
kubectl top pods -n production --containers

# Get heap dump (Java)
kubectl exec $POD_NAME -n production -- jmap -dump:format=b,file=/tmp/heap.bin $(pgrep java)
kubectl cp production/$POD_NAME:/tmp/heap.bin ./heap.bin

# Analyze Node.js memory
kubectl exec $POD_NAME -n production -- node --inspect-brk=0.0.0.0:9229

# Force garbage collection
kubectl exec $POD_NAME -n production -- kill -USR1 $(pgrep node)
```

## Post-Incident

### Incident Report Template
```markdown
# Incident Report: [Title]

**Date**: [YYYY-MM-DD]  
**Duration**: [Start time - End time]  
**Severity**: [P1/P2/P3]  
**Impact**: [Number of users/services affected]

## Timeline
- HH:MM - Alert triggered
- HH:MM - Engineer acknowledged
- HH:MM - Root cause identified
- HH:MM - Mitigation applied
- HH:MM - Service restored

## Root Cause
[Detailed explanation of what caused the incident]

## Resolution
[Steps taken to resolve the incident]

## Lessons Learned
- What went well
- What could be improved
- Action items

## Follow-up Actions
- [ ] Update runbook
- [ ] Add monitoring
- [ ] Fix root cause
- [ ] Post-mortem meeting
```

---
*Last Updated: [Date]*  
*Runbook Owner: [Name]*  
*Emergency: Call On-Call via PagerDuty*