const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const FollowUp = sequelize.define('FollowUp', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  contactId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'contacts',
      key: 'id'
    }
  },
  contactName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  contactExpoId: {
    type: DataTypes.STRING,
    allowNull: false
  },
  followUpDate: {
    type: DataTypes.DATE,
    allowNull: false
  },
  note: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  isCompleted: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  completedAt: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  tableName: 'followups',
  timestamps: true,
  indexes: [
    {
      fields: ['userId', 'followUpDate']
    },
    {
      fields: ['userId', 'isCompleted', 'followUpDate']
    },
    {
      fields: ['contactId']
    }
  ]
});

module.exports = FollowUp;
