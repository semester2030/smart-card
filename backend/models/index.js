// Import all models
const User = require('./User');
const Contact = require('./Contact');
const Note = require('./Note');
const FollowUp = require('./FollowUp');
const Lead = require('./Lead');
const Request = require('./Request');

// Define all associations
// User associations
User.hasMany(Contact, { foreignKey: 'userId', as: 'contacts' });
User.hasMany(Note, { foreignKey: 'userId', as: 'notes' });
User.hasMany(FollowUp, { foreignKey: 'userId', as: 'followUps' });
User.hasMany(Lead, { foreignKey: 'exhibitorId', as: 'exhibitorLeads' });
User.hasMany(Lead, { foreignKey: 'visitorId', as: 'visitorLeads' });
User.hasMany(Request, { foreignKey: 'visitorId', as: 'visitorRequests' });
User.hasMany(Request, { foreignKey: 'exhibitorId', as: 'exhibitorRequests' });

// Contact associations
Contact.belongsTo(User, { foreignKey: 'userId', as: 'user' });
Contact.hasMany(Note, { foreignKey: 'contactId', as: 'notes' });
Contact.hasMany(FollowUp, { foreignKey: 'contactId', as: 'followUps' });

// Note associations
Note.belongsTo(User, { foreignKey: 'userId', as: 'user' });
Note.belongsTo(Contact, { foreignKey: 'contactId', as: 'contact' });

// FollowUp associations
FollowUp.belongsTo(User, { foreignKey: 'userId', as: 'user' });
FollowUp.belongsTo(Contact, { foreignKey: 'contactId', as: 'contact' });

// Lead associations
Lead.belongsTo(User, { foreignKey: 'exhibitorId', as: 'exhibitor' });
Lead.belongsTo(User, { foreignKey: 'visitorId', as: 'visitor' });

// Request associations
Request.belongsTo(User, { foreignKey: 'visitorId', as: 'visitor' });
Request.belongsTo(User, { foreignKey: 'exhibitorId', as: 'exhibitor' });

module.exports = {
  User,
  Contact,
  Note,
  FollowUp,
  Lead,
  Request
};

