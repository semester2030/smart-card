const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Request = sequelize.define('Request', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
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
  exhibitorId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  exhibitorName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  exhibitorExpoId: {
    type: DataTypes.STRING,
    allowNull: false
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  status: {
    type: DataTypes.ENUM('pending', 'accepted', 'rejected'),
    defaultValue: 'pending'
  },
  respondedAt: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  tableName: 'requests',
  timestamps: true,
  indexes: [
    {
      fields: ['exhibitorId', 'status', 'createdAt']
    },
    {
      fields: ['visitorId', 'createdAt']
    }
  ]
});

module.exports = Request;
