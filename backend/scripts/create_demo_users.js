const { sequelize } = require('../config/database');
const { User } = require('../models');
const bcrypt = require('bcryptjs');

/**
 * Create demo accounts for testing
 */
async function createDemoUsers() {
  try {
    await sequelize.authenticate();
    console.log('✅ Connected to database');

    // Check if demo users already exist
    const existingVisitor = await User.findOne({ where: { email: 'visitor@demo.com' } });
    const existingExhibitor = await User.findOne({ where: { email: 'exhibitor@demo.com' } });

    if (existingVisitor) {
      console.log('⚠️ Visitor demo account already exists');
    } else {
      // Create Visitor demo account
      const visitorPassword = await bcrypt.hash('demo123', 10);
      const visitor = await User.create({
        name: 'محمد أحمد',
        email: 'visitor@demo.com',
        password: visitorPassword,
        phone: '+966501234567',
        role: 'visitor',
        expoId: 'SmartCard#1200',
        isVerified: true, // Skip OTP verification for demo
        otp: null,
        otpExpires: null
      });
      console.log(`✅ Created visitor demo account: ${visitor.expoId} (${visitor.email})`);
      console.log(`   Password: demo123`);
    }

    if (existingExhibitor) {
      console.log('⚠️ Exhibitor demo account already exists');
    } else {
      // Create Exhibitor demo account
      const exhibitorPassword = await bcrypt.hash('demo123', 10);
      const exhibitor = await User.create({
        name: 'شركة التقنيات الذكية',
        email: 'exhibitor@demo.com',
        password: exhibitorPassword,
        phone: '+966502345678',
        role: 'exhibitor',
        companyName: 'شركة التقنيات الذكية',
        category: 'تقنية',
        expoId: 'SmartCard#2000',
        isVerified: true, // Skip OTP verification for demo
        otp: null,
        otpExpires: null
      });
      console.log(`✅ Created exhibitor demo account: ${exhibitor.expoId} (${exhibitor.email})`);
      console.log(`   Password: demo123`);
    }

    console.log('\n✅ Demo accounts created successfully!');
    console.log('\n📋 Demo Accounts:');
    console.log('   Visitor:');
    console.log('     Email: visitor@demo.com');
    console.log('     SmartCardID: SmartCard#1200');
    console.log('     Password: demo123');
    console.log('   Exhibitor:');
    console.log('     Email: exhibitor@demo.com');
    console.log('     SmartCardID: SmartCard#2000');
    console.log('     Password: demo123');

    process.exit(0);
  } catch (error) {
    console.error('❌ Error creating demo users:', error);
    process.exit(1);
  }
}

// Run the script
createDemoUsers();

