const { Sequelize } = require('sequelize');

// Railway provides DATABASE_URL automatically
// Format: postgres://user:password@host:port/database
let sequelize;

if (process.env.DATABASE_URL) {
  // Production (Railway, Heroku, etc.)
  sequelize = new Sequelize(process.env.DATABASE_URL, {
    dialect: 'postgres',
    logging: process.env.NODE_ENV === 'development' ? console.log : false,
    dialectOptions: {
      ssl: {
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
    await sequelize.authenticate();
    const config = sequelize.config;
    console.log(`✅ PostgreSQL Connected: ${config.host}:${config.port}/${config.database}`);
    
    // Sync models (create tables if they don't exist)
    // In production, sync without alter to avoid data loss
    await sequelize.sync({ alter: false }); // Use { force: true } to drop and recreate tables (DANGEROUS!)
    console.log('✅ Database tables synced');
  } catch (error) {
    console.error(`❌ Error connecting to PostgreSQL: ${error.message}`);
    if (process.env.NODE_ENV === 'production') {
      process.exit(1);
    }
  }
};

module.exports = { sequelize, connectDB };
