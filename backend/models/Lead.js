const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Lead = sequelize.define('Lead', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  exhibitorId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  visitorId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  visitorName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  visitorExpoId: {
    type: DataTypes.STRING,
    allowNull: false
  },
  visitorEmail: {
    type: DataTypes.STRING,
    allowNull: true,
    validate: {
      isEmail: true
    }
  },
  visitorPhone: {
    type: DataTypes.STRING,
    allowNull: true
  },
  scannedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  eventId: {
    type: DataTypes.STRING,
    allowNull: true
  },
  eventName: {
    type: DataTypes.STRING,
    allowNull: true
  },
  status: {
    type: DataTypes.ENUM('new', 'contacted', 'interested', 'follow-up', 'converted', 'lost'),
    defaultValue: 'new'
  },
  aiScore: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
    validate: {
      min: 0,
      max: 100
    }
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  followUpDate: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  tableName: 'leads',
  timestamps: true,
  indexes: [
    {
      fields: ['exhibitorId', 'scannedAt']
    },
    {
      fields: ['exhibitorId', 'status']
    },
    {
      fields: ['exhibitorId', 'aiScore']
    },
    {
      fields: ['visitorId']
    }
  ]
});

module.exports = Lead;
