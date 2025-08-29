# Performance Optimization Guidelines

**Purpose**: Define performance standards, optimization techniques, and monitoring practices.  
**Audience**: Developers, DevOps, performance engineers  
**Update Frequency**: Monthly performance review, immediate for critical issues

## Performance Principles

### Core Performance Goals
1. **Fast Initial Load**: < 3 seconds on 3G
2. **Responsive Interactions**: < 100ms feedback
3. **Smooth Animations**: 60 FPS consistently
4. **Efficient Resources**: Minimize CPU, memory, bandwidth
5. **Scalable Architecture**: Linear scaling with load

### Performance Budget
| Metric | Target | Critical | Current |
|--------|---------|----------|---------|
| First Contentful Paint | < 1.0s | < 2.5s | [measure] |
| Largest Contentful Paint | < 2.5s | < 4.0s | [measure] |
| Time to Interactive | < 3.8s | < 7.3s | [measure] |
| Total Blocking Time | < 200ms | < 600ms | [measure] |
| Cumulative Layout Shift | < 0.1 | < 0.25 | [measure] |
| JavaScript Bundle Size | < 200KB | < 400KB | [measure] |
| CSS Bundle Size | < 50KB | < 100KB | [measure] |
| Image Total | < 500KB | < 1MB | [measure] |

## Frontend Optimization

### JavaScript Optimization
```javascript
// Code splitting with dynamic imports
const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <HeavyComponent />
    </Suspense>
  );
}

// Tree shaking - only import what you need
import { debounce } from 'lodash-es'; // ✅
// import _ from 'lodash'; // ❌ Imports entire library

// Memoization for expensive computations
const ExpensiveComponent = memo(({ data }) => {
  const processedData = useMemo(() => {
    return heavyProcessing(data);
  }, [data]);

  const handleClick = useCallback((id) => {
    // Handle click
  }, []);

  return <div>{processedData}</div>;
});

// Virtual scrolling for long lists
import { FixedSizeList } from 'react-window';

function VirtualList({ items }) {
  return (
    <FixedSizeList
      height={600}
      itemCount={items.length}
      itemSize={50}
      width="100%"
    >
      {({ index, style }) => (
        <div style={style}>
          {items[index].name}
        </div>
      )}
    </FixedSizeList>
  );
}
```

### CSS Optimization
```css
/* Critical CSS inline in <head> */
<style>
  /* Above-the-fold styles only */
  .hero { background: #fff; min-height: 100vh; }
  .nav { position: fixed; top: 0; width: 100%; }
</style>

/* Defer non-critical CSS */
<link rel="preload" href="styles.css" as="style" onload="this.onload=null;this.rel='stylesheet'">

/* Use CSS containment for performance */
.card {
  contain: layout style paint;
}

/* Prefer transform/opacity for animations */
.animate {
  transition: transform 0.3s, opacity 0.3s; /* GPU accelerated */
}
/* Avoid animating layout properties */
.bad-animate {
  transition: width 0.3s, height 0.3s; /* Triggers reflow */
}

/* Use will-change sparingly */
.will-animate {
  will-change: transform;
}
.will-animate:hover {
  transform: scale(1.1);
}
```

### Image Optimization
```html
<!-- Responsive images with srcset -->
<img
  srcset="image-320w.jpg 320w,
          image-640w.jpg 640w,
          image-1280w.jpg 1280w"
  sizes="(max-width: 320px) 280px,
         (max-width: 640px) 600px,
         1200px"
  src="image-640w.jpg"
  alt="Description"
  loading="lazy"
  decoding="async"
/>

<!-- Modern image formats with fallback -->
<picture>
  <source type="image/avif" srcset="image.avif">
  <source type="image/webp" srcset="image.webp">
  <img src="image.jpg" alt="Description" loading="lazy">
</picture>

<!-- Lazy loading for below-fold images -->
<img src="placeholder.jpg" data-src="actual-image.jpg" class="lazy" alt="Description">
```

```javascript
// Image lazy loading with Intersection Observer
const images = document.querySelectorAll('img[data-src]');
const imageObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const img = entry.target;
      img.src = img.dataset.src;
      img.classList.remove('lazy');
      imageObserver.unobserve(img);
    }
  });
}, {
  rootMargin: '50px 0px' // Start loading 50px before visible
});

images.forEach(img => imageObserver.observe(img));
```

### Bundle Optimization
```javascript
// webpack.config.js
module.exports = {
  optimization: {
    splitChunks: {
      chunks: 'all',
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          priority: 10
        },
        common: {
          minChunks: 2,
          priority: 5,
          reuseExistingChunk: true
        }
      }
    },
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          compress: {
            drop_console: true,
            drop_debugger: true
          }
        }
      }),
      new CssMinimizerPlugin()
    ]
  }
};

// Analyze bundle size
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
plugins: [
  new BundleAnalyzerPlugin({
    analyzerMode: 'static',
    openAnalyzer: false
  })
]
```

## Backend Optimization

### Database Query Optimization
```javascript
// Use indexes effectively
await db.query(`
  CREATE INDEX idx_users_email ON users(email);
  CREATE INDEX idx_orders_user_created ON orders(user_id, created_at DESC);
  CREATE INDEX idx_products_category_status ON products(category_id, status)
    WHERE status = 'active';
`);

// Optimize N+1 queries with eager loading
// Bad - N+1 queries
const users = await User.findAll();
for (const user of users) {
  user.orders = await Order.findAll({ where: { userId: user.id } });
}

// Good - Single query with join
const users = await User.findAll({
  include: [{
    model: Order,
    as: 'orders'
  }]
});

// Use pagination for large datasets
async function getPaginatedUsers(page = 1, limit = 20) {
  const offset = (page - 1) * limit;
  
  const { rows, count } = await User.findAndCountAll({
    limit,
    offset,
    order: [['createdAt', 'DESC']],
    attributes: ['id', 'name', 'email'], // Only select needed fields
    raw: true // Return plain objects, not model instances
  });
  
  return {
    data: rows,
    totalPages: Math.ceil(count / limit),
    currentPage: page
  };
}

// Use database-specific optimizations
// PostgreSQL: Use EXPLAIN ANALYZE
const queryPlan = await db.query(`
  EXPLAIN ANALYZE
  SELECT u.*, COUNT(o.id) as order_count
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  WHERE u.status = 'active'
  GROUP BY u.id
`);
```

### Caching Strategies
```javascript
// Multi-layer caching
class CacheService {
  constructor() {
    this.memoryCache = new Map();
    this.redisClient = redis.createClient();
  }

  async get(key, fetcher, options = {}) {
    // L1: Memory cache (fastest)
    if (this.memoryCache.has(key)) {
      return this.memoryCache.get(key);
    }

    // L2: Redis cache (fast)
    const redisValue = await this.redisClient.get(key);
    if (redisValue) {
      const value = JSON.parse(redisValue);
      this.memoryCache.set(key, value);
      return value;
    }

    // L3: Database/API (slow)
    const value = await fetcher();
    
    // Cache in both layers
    await this.set(key, value, options);
    
    return value;
  }

  async set(key, value, options = {}) {
    const ttl = options.ttl || 3600; // Default 1 hour
    
    // Memory cache with TTL
    this.memoryCache.set(key, value);
    setTimeout(() => this.memoryCache.delete(key), ttl * 1000);
    
    // Redis cache
    await this.redisClient.setex(key, ttl, JSON.stringify(value));
  }

  async invalidate(pattern) {
    // Clear memory cache
    for (const key of this.memoryCache.keys()) {
      if (key.match(pattern)) {
        this.memoryCache.delete(key);
      }
    }
    
    // Clear Redis cache
    const keys = await this.redisClient.keys(pattern);
    if (keys.length) {
      await this.redisClient.del(keys);
    }
  }
}

// Usage
const cache = new CacheService();

async function getUser(id) {
  return cache.get(
    `user:${id}`,
    () => db.users.findById(id),
    { ttl: 300 } // 5 minutes
  );
}
```

### API Response Optimization
```javascript
// Compression middleware
const compression = require('compression');
app.use(compression({
  filter: (req, res) => {
    if (req.headers['x-no-compression']) {
      return false;
    }
    return compression.filter(req, res);
  },
  level: 6, // Balance between speed and compression
  threshold: 1024 // Only compress responses > 1KB
}));

// Field filtering
router.get('/api/users', async (req, res) => {
  const fields = req.query.fields?.split(',') || ['id', 'name', 'email'];
  
  const users = await User.findAll({
    attributes: fields,
    limit: req.query.limit || 20
  });
  
  res.json(users);
});

// Response streaming for large datasets
router.get('/api/export/users', async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.write('[');
  
  let first = true;
  const stream = User.findAllStream();
  
  stream.on('data', (user) => {
    if (!first) res.write(',');
    res.write(JSON.stringify(user));
    first = false;
  });
  
  stream.on('end', () => {
    res.write(']');
    res.end();
  });
});
```

### Async Processing
```javascript
// Job queue for heavy operations
const Queue = require('bull');
const emailQueue = new Queue('emails', {
  redis: {
    port: 6379,
    host: 'localhost'
  }
});

// Producer
async function sendEmailAsync(to, template, data) {
  const job = await emailQueue.add('send-email', {
    to,
    template,
    data
  }, {
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000
    },
    removeOnComplete: true,
    removeOnFail: false
  });
  
  return job.id;
}

// Consumer
emailQueue.process('send-email', async (job) => {
  const { to, template, data } = job.data;
  
  await sendEmail(to, template, data);
  
  // Update progress
  job.progress(100);
});

// Batch processing
async function processBatch(items, batchSize = 100) {
  const results = [];
  
  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    
    // Process batch in parallel
    const batchResults = await Promise.all(
      batch.map(item => processItem(item))
    );
    
    results.push(...batchResults);
    
    // Prevent memory buildup
    if (global.gc) global.gc();
  }
  
  return results;
}
```

## Infrastructure Optimization

### Load Balancing
```nginx
# nginx.conf
upstream backend {
    least_conn;  # Least connections algorithm
    
    server backend1.example.com weight=3;
    server backend2.example.com weight=2;
    server backend3.example.com weight=1;
    
    keepalive 32;  # Connection pooling
}

server {
    location / {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        
        # Caching
        proxy_cache_valid 200 302 10m;
        proxy_cache_valid 404 1m;
        
        # Buffering
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
    }
}
```

### CDN Configuration
```javascript
// CloudFlare Workers for edge computing
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  const cache = caches.default;
  const cacheKey = new Request(request.url, request);
  
  // Check cache
  let response = await cache.match(cacheKey);
  
  if (!response) {
    // Cache miss - fetch from origin
    response = await fetch(request);
    
    // Cache successful responses
    if (response.status === 200) {
      const headers = new Headers(response.headers);
      headers.set('Cache-Control', 'public, max-age=3600');
      
      response = new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers
      });
      
      event.waitUntil(cache.put(cacheKey, response.clone()));
    }
  }
  
  return response;
}
```

### Container Optimization
```dockerfile
# Multi-stage build for smaller images
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Run as non-root user
USER node

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

EXPOSE 3000
CMD ["node", "server.js"]
```

## Monitoring & Profiling

### Performance Monitoring
```javascript
// Custom performance monitoring
class PerformanceMonitor {
  constructor() {
    this.metrics = new Map();
  }

  startTimer(label) {
    this.metrics.set(label, {
      start: performance.now(),
      marks: []
    });
  }

  mark(label, description) {
    const metric = this.metrics.get(label);
    if (metric) {
      metric.marks.push({
        time: performance.now() - metric.start,
        description
      });
    }
  }

  endTimer(label) {
    const metric = this.metrics.get(label);
    if (metric) {
      const duration = performance.now() - metric.start;
      
      // Log to monitoring service
      logger.info('Performance metric', {
        label,
        duration,
        marks: metric.marks
      });
      
      // Send to analytics
      if (window.ga) {
        ga('send', 'timing', 'Performance', label, Math.round(duration));
      }
      
      return duration;
    }
  }
}

// Usage
const monitor = new PerformanceMonitor();

monitor.startTimer('api-call');
const data = await fetchData();
monitor.mark('api-call', 'data fetched');
const processed = processData(data);
monitor.mark('api-call', 'data processed');
monitor.endTimer('api-call');
```

### Browser Performance API
```javascript
// Measure page load performance
window.addEventListener('load', () => {
  const perfData = performance.getEntriesByType('navigation')[0];
  
  const metrics = {
    dns: perfData.domainLookupEnd - perfData.domainLookupStart,
    tcp: perfData.connectEnd - perfData.connectStart,
    ttfb: perfData.responseStart - perfData.requestStart,
    download: perfData.responseEnd - perfData.responseStart,
    domParsing: perfData.domInteractive - perfData.domLoading,
    domContentLoaded: perfData.domContentLoadedEventEnd - perfData.domContentLoadedEventStart,
    load: perfData.loadEventEnd - perfData.loadEventStart,
    total: perfData.loadEventEnd - perfData.fetchStart
  };
  
  // Send to analytics
  sendToAnalytics('page-load', metrics);
});

// Observe long tasks
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 50) { // Tasks longer than 50ms
      console.warn('Long task detected:', {
        duration: entry.duration,
        startTime: entry.startTime,
        name: entry.name
      });
    }
  }
});

observer.observe({ entryTypes: ['longtask'] });
```

### Server Monitoring
```javascript
// APM integration
const apm = require('elastic-apm-node').start({
  serviceName: 'api-service',
  secretToken: process.env.APM_TOKEN,
  serverUrl: process.env.APM_SERVER_URL,
  captureBody: 'all',
  captureHeaders: true,
  transactionSampleRate: 0.1
});

// Custom metrics
const promClient = require('prom-client');

const httpDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status']
});

const dbQueryDuration = new promClient.Histogram({
  name: 'db_query_duration_seconds',
  help: 'Duration of database queries in seconds',
  labelNames: ['operation', 'table']
});

// Middleware to track HTTP metrics
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    httpDuration
      .labels(req.method, req.route?.path || 'unknown', res.statusCode)
      .observe(duration);
  });
  
  next();
});
```

## Performance Testing

### Load Testing Script
```javascript
// k6 load test
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export const options = {
  stages: [
    { duration: '2m', target: 100 },  // Ramp up
    { duration: '5m', target: 100 },  // Sustain
    { duration: '2m', target: 200 },  // Scale
    { duration: '5m', target: 200 },  // Sustain
    { duration: '2m', target: 0 },    // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    errors: ['rate<0.1'],
  },
};

export default function () {
  const response = http.get('https://api.example.com/users', {
    headers: { 'Authorization': 'Bearer token' },
  });

  const success = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  errorRate.add(!success);
  sleep(1);
}
```

## Performance Checklist

### Frontend Checklist
- [ ] Bundle size < 200KB (gzipped)
- [ ] Code splitting implemented
- [ ] Images optimized (WebP/AVIF)
- [ ] Lazy loading for images/components
- [ ] CSS critical path optimized
- [ ] Fonts optimized (subset, preload)
- [ ] Third-party scripts async/defer
- [ ] Service worker for caching
- [ ] HTTP/2 or HTTP/3 enabled
- [ ] Compression enabled

### Backend Checklist
- [ ] Database queries optimized
- [ ] Indexes properly configured
- [ ] N+1 queries eliminated
- [ ] Caching strategy implemented
- [ ] API responses paginated
- [ ] Heavy operations async
- [ ] Connection pooling configured
- [ ] Response compression enabled
- [ ] Rate limiting implemented
- [ ] CDN configured

### Infrastructure Checklist
- [ ] Auto-scaling configured
- [ ] Load balancing optimized
- [ ] CDN caching rules set
- [ ] Database replicas configured
- [ ] Monitoring alerts configured
- [ ] Performance budgets enforced
- [ ] Regular performance audits
- [ ] Capacity planning done

---
*Last Updated: [Date]*  
*Performance Lead: [Name]*