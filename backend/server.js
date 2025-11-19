const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const { connectDB } = require('./config/database');

// Load environment variables
dotenv.config();

// Import models to register them and set up associations
require('./models/index');

// Connect to database
connectDB().catch(err => {
  console.error('❌ Failed to connect to PostgreSQL');
  console.error('💡 Please check your PostgreSQL connection in .env file');
  console.error('📖 See DATABASE_OPTIONS.md for setup instructions');
  // Don't exit in development - allow server to start for testing
  if (process.env.NODE_ENV === 'production') {
    process.exit(1);
  }
});

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

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Smart Card API is running' });
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

// Railway automatically assigns PORT
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📱 Environment: ${process.env.NODE_ENV || 'development'}`);
  if (process.env.RAILWAY_ENVIRONMENT) {
    console.log(`🌐 Railway URL: https://${process.env.RAILWAY_PUBLIC_DOMAIN || 'your-app.railway.app'}`);
  } else {
    console.log(`🌐 Accessible at: http://localhost:${PORT} or http://YOUR_IP:${PORT}`);
  }
});

module.exports = app;

