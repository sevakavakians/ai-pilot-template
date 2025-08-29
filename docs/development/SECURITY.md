# Security Policies & Best Practices

**Purpose**: Define security standards, vulnerability management, and secure coding practices.  
**Audience**: All developers, security team, DevOps  
**Update Frequency**: Quarterly security review, immediate for critical updates

## Security Principles

### Core Security Tenets
1. **Defense in Depth**: Multiple layers of security controls
2. **Least Privilege**: Minimum access required
3. **Zero Trust**: Verify everything, trust nothing
4. **Fail Secure**: Deny by default
5. **Security by Design**: Built-in, not bolted-on

### OWASP Top 10 Protection
| Risk | Description | Mitigation |
|------|-------------|------------|
| Injection | SQL, NoSQL, Command injection | Parameterized queries, input validation |
| Broken Authentication | Weak authentication | MFA, secure session management |
| Sensitive Data Exposure | Unencrypted data | TLS, encryption at rest |
| XML External Entities | XXE attacks | Disable XML external entity processing |
| Broken Access Control | Unauthorized access | RBAC, proper authorization |
| Security Misconfiguration | Default configs | Hardened configurations |
| XSS | Cross-site scripting | Output encoding, CSP |
| Insecure Deserialization | Object injection | Input validation, type checking |
| Using Components with Vulnerabilities | Outdated dependencies | Regular updates, scanning |
| Insufficient Logging | Lack of monitoring | Comprehensive logging, alerting |

## Authentication & Authorization

### Authentication Implementation
```javascript
// Secure password hashing with bcrypt
const bcrypt = require('bcrypt');
const SALT_ROUNDS = 12;

async function hashPassword(password) {
  // Validate password strength
  if (!isStrongPassword(password)) {
    throw new Error('Password does not meet requirements');
  }
  
  return await bcrypt.hash(password, SALT_ROUNDS);
}

async function verifyPassword(password, hash) {
  return await bcrypt.compare(password, hash);
}

// Password requirements
function isStrongPassword(password) {
  const requirements = {
    minLength: 12,
    hasUpperCase: /[A-Z]/.test(password),
    hasLowerCase: /[a-z]/.test(password),
    hasNumbers: /\d/.test(password),
    hasSpecialChar: /[!@#$%^&*(),.?":{}|<>]/.test(password),
    notCommon: !commonPasswords.includes(password.toLowerCase())
  };
  
  return Object.values(requirements).every(req => req === true);
}
```

### JWT Token Management
```javascript
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

// Secure token generation
function generateTokens(user) {
  const payload = {
    sub: user.id,
    email: user.email,
    roles: user.roles,
    iat: Date.now()
  };

  // Short-lived access token
  const accessToken = jwt.sign(payload, process.env.JWT_SECRET, {
    expiresIn: '15m',
    algorithm: 'HS256',
    issuer: 'api.example.com',
    audience: 'app.example.com'
  });

  // Long-lived refresh token
  const refreshToken = crypto.randomBytes(32).toString('hex');
  
  // Store refresh token hash in database
  const refreshTokenHash = crypto
    .createHash('sha256')
    .update(refreshToken)
    .digest('hex');
    
  return { accessToken, refreshToken, refreshTokenHash };
}

// Token validation middleware
function validateToken(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET, {
      algorithms: ['HS256'],
      issuer: 'api.example.com',
      audience: 'app.example.com'
    });
    
    req.user = decoded;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ error: 'Token expired' });
    }
    return res.status(403).json({ error: 'Invalid token' });
  }
}
```

### Multi-Factor Authentication
```javascript
const speakeasy = require('speakeasy');
const QRCode = require('qrcode');

// Setup MFA for user
async function setupMFA(user) {
  const secret = speakeasy.generateSecret({
    name: `App (${user.email})`,
    issuer: 'YourApp',
    length: 32
  });

  // Generate QR code
  const qrCodeUrl = await QRCode.toDataURL(secret.otpauth_url);

  // Store encrypted secret
  const encryptedSecret = encrypt(secret.base32);
  await db.users.update(user.id, {
    mfa_secret: encryptedSecret,
    mfa_enabled: false // Enable after first successful verification
  });

  return {
    secret: secret.base32,
    qrCode: qrCodeUrl,
    backupCodes: generateBackupCodes()
  };
}

// Verify MFA token
function verifyMFAToken(user, token) {
  const secret = decrypt(user.mfa_secret);
  
  return speakeasy.totp.verify({
    secret,
    encoding: 'base32',
    token,
    window: 2 // Allow 2 intervals before/after
  });
}
```

### Role-Based Access Control (RBAC)
```javascript
// Permission definitions
const permissions = {
  'user:read': ['admin', 'manager', 'user'],
  'user:write': ['admin', 'manager'],
  'user:delete': ['admin'],
  'report:view': ['admin', 'manager', 'analyst'],
  'system:configure': ['admin']
};

// Authorization middleware
function authorize(requiredPermission) {
  return (req, res, next) => {
    const userRoles = req.user.roles || [];
    const allowedRoles = permissions[requiredPermission] || [];
    
    const hasPermission = userRoles.some(role => 
      allowedRoles.includes(role)
    );
    
    if (!hasPermission) {
      return res.status(403).json({
        error: 'Insufficient permissions',
        required: requiredPermission
      });
    }
    
    next();
  };
}

// Usage
router.get('/users', authorize('user:read'), getUsers);
router.post('/users', authorize('user:write'), createUser);
router.delete('/users/:id', authorize('user:delete'), deleteUser);
```

## Input Validation & Sanitization

### Input Validation Rules
```javascript
const validator = require('validator');
const DOMPurify = require('isomorphic-dompurify');

// Validation middleware
function validateInput(rules) {
  return (req, res, next) => {
    const errors = [];
    
    for (const field in rules) {
      const value = req.body[field];
      const fieldRules = rules[field];
      
      // Required check
      if (fieldRules.required && !value) {
        errors.push(`${field} is required`);
        continue;
      }
      
      // Type validation
      if (fieldRules.type === 'email' && !validator.isEmail(value)) {
        errors.push(`${field} must be a valid email`);
      }
      
      if (fieldRules.type === 'url' && !validator.isURL(value)) {
        errors.push(`${field} must be a valid URL`);
      }
      
      // Length validation
      if (fieldRules.minLength && value.length < fieldRules.minLength) {
        errors.push(`${field} must be at least ${fieldRules.minLength} characters`);
      }
      
      // Pattern validation
      if (fieldRules.pattern && !fieldRules.pattern.test(value)) {
        errors.push(`${field} format is invalid`);
      }
      
      // Sanitization
      if (fieldRules.sanitize) {
        req.body[field] = sanitizeInput(value, fieldRules.sanitize);
      }
    }
    
    if (errors.length > 0) {
      return res.status(400).json({ errors });
    }
    
    next();
  };
}

// Sanitization functions
function sanitizeInput(value, type) {
  switch (type) {
    case 'html':
      return DOMPurify.sanitize(value);
    case 'sql':
      return value.replace(/['";\\]/g, '');
    case 'filename':
      return value.replace(/[^a-zA-Z0-9._-]/g, '');
    case 'alphanumeric':
      return value.replace(/[^a-zA-Z0-9]/g, '');
    default:
      return validator.escape(value);
  }
}
```

### SQL Injection Prevention
```javascript
// NEVER do this - vulnerable to SQL injection
const query = `SELECT * FROM users WHERE email = '${email}'`; // ❌

// Use parameterized queries
const query = 'SELECT * FROM users WHERE email = ?';
db.query(query, [email]); // ✅

// Using query builders (Knex.js)
const user = await knex('users')
  .where('email', email)
  .andWhere('status', 'active')
  .first();

// Using ORMs (Sequelize)
const user = await User.findOne({
  where: {
    email: email,
    status: 'active'
  }
});
```

### XSS Prevention
```javascript
// Content Security Policy
app.use((req, res, next) => {
  res.setHeader(
    'Content-Security-Policy',
    "default-src 'self'; " +
    "script-src 'self' 'unsafe-inline' https://trusted-cdn.com; " +
    "style-src 'self' 'unsafe-inline'; " +
    "img-src 'self' data: https:; " +
    "font-src 'self' data:; " +
    "connect-src 'self' https://api.example.com; " +
    "frame-ancestors 'none'; " +
    "base-uri 'self'; " +
    "form-action 'self'"
  );
  next();
});

// Output encoding in templates
// Using handlebars
<div>{{{sanitizedHtml}}}</div>  <!-- Pre-sanitized HTML -->
<div>{{userInput}}</div>         <!-- Auto-escaped -->

// React automatically escapes
<div>{userInput}</div>            <!-- Safe by default -->
<div dangerouslySetInnerHTML={{__html: sanitizedHtml}} />  <!-- Use with caution -->
```

## Data Protection

### Encryption at Rest
```javascript
const crypto = require('crypto');

class Encryption {
  constructor() {
    this.algorithm = 'aes-256-gcm';
    this.key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
  }

  encrypt(text) {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipheriv(this.algorithm, this.key, iv);
    
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    
    const authTag = cipher.getAuthTag();
    
    return {
      encrypted,
      iv: iv.toString('hex'),
      authTag: authTag.toString('hex')
    };
  }

  decrypt(encryptedData) {
    const decipher = crypto.createDecipheriv(
      this.algorithm,
      this.key,
      Buffer.from(encryptedData.iv, 'hex')
    );
    
    decipher.setAuthTag(Buffer.from(encryptedData.authTag, 'hex'));
    
    let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    
    return decrypted;
  }
}

// Usage for sensitive data
const encryption = new Encryption();

// Encrypt before storing
const ssn = '123-45-6789';
const encryptedSSN = encryption.encrypt(ssn);
await db.users.update(userId, { ssn: JSON.stringify(encryptedSSN) });

// Decrypt when needed
const storedSSN = JSON.parse(user.ssn);
const decryptedSSN = encryption.decrypt(storedSSN);
```

### Secure File Upload
```javascript
const multer = require('multer');
const path = require('path');
const crypto = require('crypto');

// File upload configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    // Generate unique filename
    const uniqueName = crypto.randomBytes(16).toString('hex');
    const ext = path.extname(file.originalname);
    cb(null, `${uniqueName}${ext}`);
  }
});

const fileFilter = (req, file, cb) => {
  // Allowed file types
  const allowedTypes = /jpeg|jpg|png|gif|pdf/;
  const extname = allowedTypes.test(
    path.extname(file.originalname).toLowerCase()
  );
  const mimetype = allowedTypes.test(file.mimetype);

  if (mimetype && extname) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type'));
  }
};

const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
    files: 10 // Max 10 files
  }
});

// Virus scanning integration
const NodeClam = require('clamscan');
const clamscan = new NodeClam().init({
  clamdscan: {
    host: 'localhost',
    port: 3310
  }
});

async function scanFile(filePath) {
  const { isInfected, viruses } = await clamscan.scanFile(filePath);
  
  if (isInfected) {
    await fs.unlink(filePath); // Delete infected file
    throw new Error(`File infected with: ${viruses.join(', ')}`);
  }
  
  return true;
}
```

## API Security

### Rate Limiting
```javascript
const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');

// General API rate limit
const apiLimiter = rateLimit({
  store: new RedisStore({
    client: redisClient,
    prefix: 'rl:api:'
  }),
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false
});

// Strict limit for sensitive endpoints
const authLimiter = rateLimit({
  store: new RedisStore({
    client: redisClient,
    prefix: 'rl:auth:'
  }),
  windowMs: 15 * 60 * 1000,
  max: 5, // Only 5 attempts
  skipSuccessfulRequests: true // Don't count successful logins
});

// Apply limiters
app.use('/api/', apiLimiter);
app.use('/api/auth/login', authLimiter);
```

### API Key Management
```javascript
const crypto = require('crypto');

// Generate API key
function generateAPIKey() {
  const key = crypto.randomBytes(32).toString('hex');
  const hash = crypto.createHash('sha256').update(key).digest('hex');
  
  return {
    key: `sk_live_${key}`, // Return to user
    hash: hash // Store in database
  };
}

// Validate API key
async function validateAPIKey(req, res, next) {
  const apiKey = req.headers['x-api-key'];
  
  if (!apiKey) {
    return res.status(401).json({ error: 'API key required' });
  }
  
  // Extract actual key from format
  const key = apiKey.replace('sk_live_', '');
  const hash = crypto.createHash('sha256').update(key).digest('hex');
  
  // Check in database
  const validKey = await db.apiKeys.findOne({ hash, active: true });
  
  if (!validKey) {
    return res.status(403).json({ error: 'Invalid API key' });
  }
  
  // Track usage
  await db.apiKeys.increment('usage_count', { where: { id: validKey.id } });
  
  req.apiKey = validKey;
  next();
}
```

## Security Headers

### HTTP Security Headers
```javascript
const helmet = require('helmet');

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'", "https://trusted.com"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));

// Additional security headers
app.use((req, res, next) => {
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');
  res.removeHeader('X-Powered-By');
  next();
});
```

## Session Security

### Secure Session Configuration
```javascript
const session = require('express-session');
const RedisStore = require('connect-redis')(session);

app.use(session({
  store: new RedisStore({
    client: redisClient,
    prefix: 'sess:',
    ttl: 3600 // 1 hour
  }),
  secret: process.env.SESSION_SECRET,
  name: 'sessionId', // Don't use default 'connect.sid'
  resave: false,
  saveUninitialized: false,
  rolling: true, // Reset expiry on activity
  cookie: {
    secure: true, // HTTPS only
    httpOnly: true, // No JavaScript access
    maxAge: 3600000, // 1 hour
    sameSite: 'strict', // CSRF protection
    domain: '.example.com' // Limit to domain
  }
}));

// Session fixation protection
app.use((req, res, next) => {
  if (req.session && req.session.regenerateOnLogin) {
    req.session.regenerate((err) => {
      if (err) next(err);
      req.session.regenerateOnLogin = false;
      next();
    });
  } else {
    next();
  }
});
```

## Logging & Monitoring

### Security Event Logging
```javascript
const winston = require('winston');

// Security logger configuration
const securityLogger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  defaultMeta: { service: 'security' },
  transports: [
    new winston.transports.File({ 
      filename: 'logs/security.log',
      maxsize: 10485760, // 10MB
      maxFiles: 10
    }),
    new winston.transports.Console({
      format: winston.format.simple()
    })
  ]
});

// Log security events
function logSecurityEvent(event, details) {
  securityLogger.info({
    event,
    ...details,
    timestamp: new Date().toISOString(),
    ip: details.req?.ip,
    userAgent: details.req?.get('user-agent')
  });
}

// Usage
logSecurityEvent('LOGIN_ATTEMPT', {
  userId: user.id,
  success: true,
  method: 'password'
});

logSecurityEvent('AUTHORIZATION_FAILURE', {
  userId: user.id,
  resource: '/api/admin',
  permission: 'admin:access'
});

logSecurityEvent('SUSPICIOUS_ACTIVITY', {
  type: 'multiple_failed_logins',
  ip: req.ip,
  attempts: 10
});
```

## Dependency Security

### Vulnerability Scanning
```json
// package.json
{
  "scripts": {
    "audit": "npm audit",
    "audit:fix": "npm audit fix",
    "check:dependencies": "npm-check-updates",
    "scan:vulnerabilities": "snyk test",
    "scan:licenses": "license-checker --summary"
  }
}
```

### Automated Security Checks
```yaml
# .github/workflows/security.yml
name: Security Scan

on:
  push:
  pull_request:
  schedule:
    - cron: '0 0 * * *' # Daily

jobs:
  security:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Run npm audit
        run: npm audit --audit-level=moderate
        
      - name: Run Snyk scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
          
      - name: Run Trivy scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          
      - name: SAST Scan
        uses: github/super-linter@v4
        env:
          DEFAULT_BRANCH: main
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Incident Response

### Security Incident Procedure
1. **Detect**: Identify the incident
2. **Contain**: Isolate affected systems
3. **Investigate**: Determine scope and impact
4. **Eradicate**: Remove the threat
5. **Recover**: Restore normal operations
6. **Document**: Create incident report

### Emergency Contacts
| Role | Contact | Escalation |
|------|---------|------------|
| Security Lead | security@example.com | Immediate |
| DevOps On-Call | +1-XXX-XXX-XXXX | < 15 min |
| CTO | cto@example.com | < 1 hour |
| Legal | legal@example.com | As needed |

## Security Checklist

### Development Checklist
- [ ] Input validation implemented
- [ ] Output encoding applied
- [ ] Authentication required
- [ ] Authorization checked
- [ ] Sensitive data encrypted
- [ ] SQL queries parameterized
- [ ] Dependencies updated
- [ ] Security headers configured
- [ ] Errors handled securely
- [ ] Logging implemented

### Deployment Checklist
- [ ] SSL/TLS configured
- [ ] Secrets in environment variables
- [ ] Debug mode disabled
- [ ] Default credentials changed
- [ ] Unnecessary ports closed
- [ ] File permissions restricted
- [ ] Backup strategy implemented
- [ ] Monitoring enabled
- [ ] Incident response plan ready

---
*Last Updated: [Date]*  
*Security Officer: [Name]*  
*Emergency Contact: security@example.com*