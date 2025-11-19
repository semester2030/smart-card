const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const { connectDB } = require('./config/database');

// Load environment variables
dotenv.config();

// Import models to register them and set up associations
require('./models/index');

// CRITICAL: Server MUST start immediately - Database connection in background
// Railway health check requires server to respond within seconds
setTimeout(() => {
  connectDB().catch(err => {
    console.error('❌ Failed to connect to PostgreSQL');
    console.error('💡 Will retry in background...');
    // Retry every 10 seconds in production
    if (process.env.NODE_ENV === 'production') {
      const retryInterval = setInterval(() => {
        connectDB().then(() => {
          clearInterval(retryInterval);
          console.log('✅ Database connected after retry');
        }).catch(() => {
          // Silent retry
        });
      }, 10000);
    }
  });
}, 100); // Start DB connection 100ms after server starts

const app = express();

// Middleware
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/users', require('./routes/users'));
app.use('/api/contacts', require('./routes/contacts'));
app.use('/api/notes', require('./routes/notes'));
app.use('/api/followups', require('./routes/followups'));
app.use('/api/leads', require('./routes/leads'));
app.use('/api/requests', require('./routes/requests'));
app.use('/api/stats', require('./routes/stats'));

// Root route
app.get('/', (req, res) => {
  res.json({ 
    success: true,
    message: 'Smart Card API',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      auth: '/api/auth',
      users: '/api/users',
      contacts: '/api/contacts',
      notes: '/api/notes',
      followups: '/api/followups',
      leads: '/api/leads',
      requests: '/api/requests',
      stats: '/api/stats'
    }
  });
});

// API root route - shows available endpoints
app.get('/api', (req, res) => {
  res.json({ 
    success: true,
    message: 'Smart Card API',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      auth: '/api/auth',
      users: '/api/users',
      contacts: '/api/contacts',
      notes: '/api/notes',
      followups: '/api/followups',
      leads: '/api/leads',
      requests: '/api/requests',
      stats: '/api/stats'
    },
    note: 'Use specific endpoints like /api/health, /api/auth, etc.'
  });
});

// Health check - Railway uses this to verify the service is running
// CRITICAL: Must respond INSTANTLY - NO database queries, NO async operations!
app.get('/health', (req, res) => {
  // Log health check (for debugging)
  console.log(`[${new Date().toISOString()}] Health check requested`);
  
  // Immediate response - no delays, no database, no async
  const response = { 
    status: 'OK', 
    message: 'Smart Card API is running',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  };
  
  // Set proper headers
  res.setHeader('Content-Type', 'application/json');
  res.status(200).json(response);
});

app.get('/api/health', (req, res) => {
  // Log health check (for debugging)
  console.log(`[${new Date().toISOString()}] API Health check requested`);
  
  // Immediate response - no delays, no database, no async
  const response = { 
    status: 'OK', 
    message: 'Smart Card API is running',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  };
  
  // Set proper headers
  res.setHeader('Content-Type', 'application/json');
  res.status(200).json(response);
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

const PORT = process.env.PORT || 3000;

// CRITICAL: Start server IMMEDIATELY - don't wait for anything
// Railway automatically assigns PORT
// Listen on 0.0.0.0 to accept connections from all network interfaces (required for Railway)

// Log BEFORE starting server (important for Railway logs)
console.log('🔧 Starting Smart Card API Server...');
console.log(`📋 PORT: ${PORT}`);
console.log(`📋 NODE_ENV: ${process.env.NODE_ENV || 'development'}`);

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log('='.repeat(50));
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📱 Environment: ${process.env.NODE_ENV || 'development'}`);
  if (process.env.RAILWAY_ENVIRONMENT) {
    console.log(`🌐 Railway URL: https://${process.env.RAILWAY_PUBLIC_DOMAIN || 'your-app.railway.app'}`);
  } else {
    console.log(`🌐 Accessible at: http://localhost:${PORT} or http://YOUR_IP:${PORT}`);
  }
  console.log(`✅ Health check available at: http://0.0.0.0:${PORT}/health`);
  console.log(`✅ Server is READY - Railway health check can now succeed`);
  console.log('='.repeat(50));
  
  // Force flush logs (important for Railway)
  if (process.stdout && typeof process.stdout.write === 'function') {
    process.stdout.write('');
  }
});

// Handle server errors gracefully
server.on('error', (error) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`❌ Port ${PORT} is already in use`);
  } else {
    console.error(`❌ Server error: ${error.message}`);
  }
});

// Keep server alive - don't let it exit
process.on('SIGTERM', () => {
  console.log('⚠️ SIGTERM received, shutting down gracefully...');
  server.close(() => {
    console.log('✅ Server closed');
    process.exit(0);
  });
});

module.exports = app;

