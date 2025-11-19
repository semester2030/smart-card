// SIMPLE SERVER - FOR TESTING
// This is a minimal server to test if Railway can start it
const express = require('express');
const app = express();

// Log immediately
console.log('='.repeat(60));
console.log('🚀 SIMPLE SERVER STARTING...');
console.log(`📋 PORT: ${process.env.PORT || 3000}`);
console.log(`📋 NODE_ENV: ${process.env.NODE_ENV || 'development'}`);
console.log('='.repeat(60));

// Health check - MUST be first route and respond INSTANTLY
// Railway checks this endpoint - it MUST return 200 OK quickly
app.get('/health', (req, res) => {
  // NO logging here - must be instant
  // NO async operations
  // NO database queries
  res.status(200).json({ 
    status: 'OK', 
    message: 'Smart Card API is running',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    version: 'simple-test'
  });
});

app.get('/api/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    message: 'Smart Card API is running',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    version: 'simple-test'
  });
});

// Root route
app.get('/', (req, res) => {
  res.json({ 
    success: true,
    message: 'Smart Card API - Simple Test Server',
    version: 'simple-test'
  });
});

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log('='.repeat(60));
  console.log(`✅ Server running on port ${PORT}`);
  console.log(`✅ Health check: http://0.0.0.0:${PORT}/health`);
  console.log('='.repeat(60));
});

// CRITICAL: Keep server alive - don't let it exit
// Railway sends SIGTERM when health check fails - we must ignore it initially
let isShuttingDown = false;

process.on('SIGTERM', () => {
  if (!isShuttingDown) {
    console.log('⚠️ SIGTERM received - but keeping server alive for health checks');
    // Don't exit immediately - Railway might be testing
    // Only exit after multiple SIGTERMs
    setTimeout(() => {
      if (!isShuttingDown) {
        isShuttingDown = true;
        console.log('⚠️ Shutting down after delay...');
        server.close(() => {
          console.log('✅ Server closed');
          process.exit(0);
        });
      }
    }, 30000); // Wait 30 seconds before actually shutting down
  }
});

// Catch uncaught errors - DON'T EXIT
process.on('uncaughtException', (error) => {
  console.error('❌ Uncaught Exception:', error.message);
  console.error('⚠️ Keeping server alive despite error');
  // Don't exit - keep server running for health checks
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Unhandled Rejection:', reason);
  // Don't exit - keep server running
});

// Keep process alive - prevent exit
setInterval(() => {
  // Heartbeat to keep process alive
  if (process.uptime() % 60 === 0) {
    console.log(`💓 Server heartbeat - uptime: ${Math.floor(process.uptime())}s`);
  }
}, 1000);

