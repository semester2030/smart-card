const { Sequelize } = require('sequelize');

// Railway provides DATABASE_URL automatically
// Format: postgres://user:password@host:port/database
let sequelize;

if (process.env.DATABASE_URL) {
  // Production (Railway, Heroku, etc.)
  // Railway uses internal networking - check if URL contains .railway.internal
  const isRailwayInternal = process.env.DATABASE_URL.includes('.railway.internal');
  
  sequelize = new Sequelize(process.env.DATABASE_URL, {
    dialect: 'postgres',
    logging: process.env.NODE_ENV === 'development' ? console.log : false,
    dialectOptions: {
      // Only use SSL for external connections, not internal Railway connections
      ssl: isRailwayInternal ? false : {
        require: true,
        rejectUnauthorized: false
      }
    },
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  });
} else {
  // Development (local)
  sequelize = new Sequelize(
    process.env.DATABASE_NAME || 'smartcard',
    process.env.DATABASE_USER || process.env.USER || 'fayez',
    process.env.DATABASE_PASSWORD || '',
    {
      host: process.env.DATABASE_HOST || 'localhost',
      port: process.env.DATABASE_PORT || 5432,
      dialect: 'postgres',
      logging: process.env.NODE_ENV === 'development' ? console.log : false,
      pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
      }
    }
  );
}

// Test connection
const connectDB = async () => {
  try {
    // Log connection attempt
    if (process.env.DATABASE_URL) {
      const dbUrl = process.env.DATABASE_URL;
      const isInternal = dbUrl.includes('.railway.internal');
      console.log(`🔌 Attempting to connect to PostgreSQL...`);
      console.log(`📍 Connection type: ${isInternal ? 'Internal (Railway)' : 'External'}`);
      console.log(`🔗 Host: ${dbUrl.match(/@([^:]+):/)?.[1] || 'unknown'}`);
    }
    
    // Set timeout for connection (10 seconds)
    await Promise.race([
      sequelize.authenticate(),
      new Promise((_, reject) => 
        setTimeout(() => reject(new Error('Connection timeout')), 10000)
      )
    ]);
    
    const config = sequelize.config;
    console.log(`✅ PostgreSQL Connected: ${config.host}:${config.port}/${config.database}`);
    
    // Sync models (create tables if they don't exist)
    // In production, sync without alter to avoid data loss
    // Use timeout to avoid blocking server start
    await Promise.race([
      sequelize.sync({ alter: false }),
      new Promise((_, reject) => 
        setTimeout(() => reject(new Error('Sync timeout')), 15000)
      )
    ]);
    console.log('✅ Database tables synced');
    return true;
  } catch (error) {
    console.error(`❌ Error connecting to PostgreSQL: ${error.message}`);
    console.error(`❌ Error code: ${error.code || 'N/A'}`);
    
    // More detailed error logging
    if (error.original) {
      console.error(`❌ Original error: ${error.original.message}`);
    }
    
    // In production, don't throw - let server start for health checks
    if (process.env.NODE_ENV === 'production') {
      console.error('⚠️ Production mode: Server will continue - database operations may fail');
      console.error('⚠️ Will retry database connection in background...');
      // Retry connection in background (non-blocking)
      setTimeout(() => {
        connectDB().catch(() => {
          // Silent retry - don't spam logs
        });
      }, 5000);
      return false; // Don't throw - allow server to start
    }
    throw error; // In development, throw to see errors
  }
};

module.exports = { sequelize, connectDB };
