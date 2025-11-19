const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');
const bcrypt = require('bcryptjs');

const User = sequelize.define('User', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  expoId: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: true
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      len: [6, 255]
    }
  },
  role: {
    type: DataTypes.ENUM('visitor', 'exhibitor'),
    allowNull: false
  },
  companyName: {
    type: DataTypes.STRING,
    allowNull: true
  },
  category: {
    type: DataTypes.STRING,
    allowNull: true
  },
  interests: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    allowNull: true,
    defaultValue: []
  },
  isVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  otpCode: {
    type: DataTypes.STRING,
    allowNull: true
  },
  otpExpiresAt: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  tableName: 'users',
  timestamps: true,
  hooks: {
    beforeCreate: async (user, options) => {
      // ALWAYS generate expoId - this is critical
      let isUnique = false;
      let attempts = 0;
      const maxAttempts = 100;
      
      // Generate unique expoId
      while (!isUnique && attempts < maxAttempts) {
        const num = Math.floor(Math.random() * 9000) + 1000;
        const generatedId = `SmartCard#${num}`;
        
        // Check if this ID already exists
        const { sequelize } = require('../config/database');
        const existing = await sequelize.models.User.findOne({ 
          where: { expoId: generatedId } 
        });
        
        if (!existing) {
          user.expoId = generatedId;
          isUnique = true;
        } else {
          attempts++;
        }
      }
      
      // If still not unique after max attempts, use timestamp-based ID
      if (!isUnique) {
        const timestamp = Date.now().toString().slice(-6);
        user.expoId = `SmartCard#${timestamp}`;
      }
      
      // Final safety check - ensure expoId is NEVER null
      if (!user.expoId || user.expoId.trim() === '') {
        user.expoId = `SmartCard#${Date.now()}`;
      }
      
      // Hash password
      if (user.password) {
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(user.password, salt);
      }
    },
    beforeUpdate: async (user) => {
      // Hash password if changed
      if (user.changed('password')) {
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(user.password, salt);
      }
    }
  }
});

// Instance method: Compare password
User.prototype.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// Static method: Generate SmartCard ID
User.generateSmartCardId = function() {
  const num = Math.floor(Math.random() * 9000) + 1000;
  return `SmartCard#${num}`;
};

module.exports = User;
