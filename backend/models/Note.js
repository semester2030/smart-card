const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Note = sequelize.define('Note', {
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
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  }
}, {
  tableName: 'notes',
  timestamps: true,
  indexes: [
    {
      fields: ['userId', 'contactId', 'createdAt']
    },
    {
      fields: ['contactId']
    }
  ]
});

module.exports = Note;
