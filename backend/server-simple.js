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

// Health check - MUST be first route
app.get('/health', (req, res) => {
  console.log(`[${new Date().toISOString()}] Health check requested`);
  res.setHeader('Content-Type', 'application/json');
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
  console.log(`[${new Date().toISOString()}] API Health check requested`);
  res.setHeader('Content-Type', 'application/json');
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

// Keep alive
process.on('SIGTERM', () => {
  console.log('⚠️ SIGTERM received');
  server.close(() => {
    console.log('✅ Server closed');
    process.exit(0);
  });
});

// Catch uncaught errors
process.on('uncaughtException', (error) => {
  console.error('❌ Uncaught Exception:', error);
  // Don't exit - keep server running
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Unhandled Rejection:', reason);
  // Don't exit - keep server running
});

