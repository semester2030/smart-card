const { sequelize } = require('../config/database');
const { User } = require('../models');
const DEFAULT_PASSWORD = 'demo123';

async function resetDemoUser(user, extra = {}) {
  user.password = DEFAULT_PASSWORD;
  user.isVerified = true;
  user.otp = null;
  user.otpExpires = null;
  Object.assign(user, extra);
  await user.save();
  console.log(`♻️  Updated demo account: ${user.email}`);
}

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
      await resetDemoUser(existingVisitor);
    } else {
      // Create Visitor demo account
      const visitor = await User.create({
        name: 'محمد أحمد',
        email: 'visitor@demo.com',
        password: DEFAULT_PASSWORD,
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
      await resetDemoUser(existingExhibitor, {
        companyName: 'شركة التقنيات الذكية',
        category: 'تقنية'
      });
    } else {
      // Create Exhibitor demo account
      const exhibitor = await User.create({
        name: 'شركة التقنيات الذكية',
        email: 'exhibitor@demo.com',
        password: DEFAULT_PASSWORD,
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

