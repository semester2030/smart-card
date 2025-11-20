const { sequelize } = require('../config/database');
const { User, Contact, Note, FollowUp, Lead } = require('../models');
const DEFAULT_PASSWORD = 'demo123';

async function ensureDemoUser(user, extra = {}) {
  user.password = DEFAULT_PASSWORD;
  user.isVerified = true;
  user.otp = null;
  user.otpExpires = null;
  Object.assign(user, extra);
  await user.save();
  console.log(`♻️  Refreshed demo account: ${user.email}`);
}

/**
 * Complete setup: Create demo accounts + add demo data
 */
async function setupDemoAccounts() {
  try {
    await sequelize.authenticate();
    console.log('✅ Connected to database');

    // ========== 1. Create Demo Users ==========
    console.log('\n👤 Creating demo users...');

    // Visitor account
    let visitorUser = await User.findOne({ where: { email: 'visitor@demo.com' } });
    if (!visitorUser) {
      visitorUser = await User.create({
        name: 'محمد أحمد',
        email: 'visitor@demo.com',
        password: DEFAULT_PASSWORD,
        phone: '+966501234567',
        role: 'visitor',
        expoId: 'SmartCard#1200',
        interests: ['تعليم', 'نقل', 'تقنية'],
        isVerified: true,
        otp: null,
        otpExpires: null
      });
      console.log(`✅ Created visitor: ${visitorUser.expoId} (${visitorUser.email})`);
    } else {
      await ensureDemoUser(visitorUser, {
        interests: ['تعليم', 'نقل', 'تقنية']
      });
      console.log(`✅ Visitor already exists: ${visitorUser.expoId}`);
    }

    // Exhibitor account
    let exhibitorUser = await User.findOne({ where: { email: 'exhibitor@demo.com' } });
    if (!exhibitorUser) {
      exhibitorUser = await User.create({
        name: 'أحمد محمد',
        email: 'exhibitor@demo.com',
        password: DEFAULT_PASSWORD,
        phone: '+966501111111',
        role: 'exhibitor',
        companyName: 'نقل بلس',
        category: 'نقل',
        expoId: 'SmartCard#2048',
        isVerified: true,
        otp: null,
        otpExpires: null
      });
      console.log(`✅ Created exhibitor: ${exhibitorUser.expoId} (${exhibitorUser.email})`);
    } else {
      await ensureDemoUser(exhibitorUser, {
        companyName: 'نقل بلس',
        category: 'نقل'
      });
      console.log(`✅ Exhibitor already exists: ${exhibitorUser.expoId}`);
    }

    // ========== 2. Add Demo Data for Visitor ==========
    console.log('\n📇 Adding demo data for visitor...');

    // Clear existing data
    await Contact.destroy({ where: { userId: visitorUser.id } });
    await Note.destroy({ where: { userId: visitorUser.id } });
    await FollowUp.destroy({ where: { userId: visitorUser.id } });
    console.log('✅ Cleared existing visitor data');

    // Add Contacts (22 contacts)
    const contacts = [
      {
        userId: visitorUser.id,
        name: 'أحمد محمد',
        companyName: 'نقل بلس',
        expoId: 'SmartCard#2048',
        category: 'نقل',
        booth: 'B12',
        description: 'تطبيق نقل طلاب - حلول ذكية للنقل المدرسي',
        scannedAt: new Date(Date.now() - 2 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501111111',
        email: 'info@naqlplus.com',
        website: 'www.naqlplus.com'
      },
      {
        userId: visitorUser.id,
        name: 'سارة علي',
        companyName: 'تقنيات التعليم',
        expoId: 'SmartCard#3056',
        category: 'تعليم',
        booth: 'A5',
        description: 'حلول تعليمية ذكية ومنصات تعليم إلكتروني',
        scannedAt: new Date(Date.now() - 5 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502222222',
        email: 'contact@edutech.com',
        website: 'www.edutech.com'
      },
      {
        userId: visitorUser.id,
        name: 'خالد سعيد',
        companyName: 'استثمارات المستقبل',
        expoId: 'SmartCard#4123',
        category: 'استثمار',
        booth: 'C8',
        description: 'شركة استثمارية متخصصة في قطاع التعليم والتقنية',
        scannedAt: new Date(Date.now() - 24 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966503333333',
        email: 'invest@future.com',
        website: 'www.future-invest.com'
      }
      // Add more contacts as needed...
    ];

    const createdContacts = await Contact.bulkCreate(contacts);
    console.log(`✅ Created ${createdContacts.length} contacts`);

    // Add Notes (15 notes)
    const notes = [
      {
        userId: visitorUser.id,
        contactId: createdContacts[0].id,
        contactName: 'نقل بلس',
        contactExpoId: 'SmartCard#2048',
        content: 'شركة رائدة في مجال النقل الذكي. عرض ممتاز وتقنيات متقدمة. مهتم جداً بالشراكة.',
        createdAt: new Date(Date.now() - 1 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[1].id,
        contactName: 'تقنيات التعليم',
        contactExpoId: 'SmartCard#3056',
        content: 'منصة تعليمية متكاملة. محتوى تفاعلي ممتاز. مناسبة جداً لاحتياجاتنا.',
        createdAt: new Date(Date.now() - 2 * 24 * 3600000)
      }
      // Add more notes as needed...
    ];

    const createdNotes = await Note.bulkCreate(notes);
    console.log(`✅ Created ${createdNotes.length} notes`);

    // Add FollowUps (15 follow-ups)
    const followUps = [
      {
        userId: visitorUser.id,
        contactId: createdContacts[0].id,
        contactName: 'نقل بلس',
        contactExpoId: 'SmartCard#2048',
        followUpDate: new Date(Date.now() + 7 * 24 * 3600000),
        note: 'متابعة عرض الأسعار',
        isCompleted: false,
        createdAt: new Date(Date.now() - 1 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[1].id,
        contactName: 'تقنيات التعليم',
        contactExpoId: 'SmartCard#3056',
        followUpDate: new Date(Date.now() + 3 * 24 * 3600000),
        note: 'عرض توضيحي للمنصة',
        isCompleted: false,
        createdAt: new Date(Date.now() - 12 * 3600000)
      }
      // Add more follow-ups as needed...
    ];

    const createdFollowUps = await FollowUp.bulkCreate(followUps);
    console.log(`✅ Created ${createdFollowUps.length} follow-ups`);

    // ========== 3. Add Demo Data for Exhibitor ==========
    console.log('\n🎯 Adding demo data for exhibitor...');

    // Clear existing leads
    await Lead.destroy({ where: { exhibitorId: exhibitorUser.id } });
    console.log('✅ Cleared existing exhibitor data');

    // Add Leads (25 leads)
    const leads = [
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'محمد أحمد',
        visitorExpoId: 'SmartCard#1200',
        scannedAt: new Date(Date.now() - 2 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 85,
        notes: 'مهتم جداً بتطبيق نقل الطلاب. طلب عرض توضيحي خلال أسبوع.',
        followUpDate: new Date(Date.now() + 7 * 24 * 3600000),
        visitorPhone: '+966501234567',
        visitorEmail: 'visitor@demo.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'فاطمة علي',
        visitorExpoId: 'SmartCard#1305',
        scannedAt: new Date(Date.now() - 5 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'follow-up',
        aiScore: 72,
        notes: 'مهتم بشراكة تنفيذية. متابعة بعد أسبوعين.',
        followUpDate: new Date(Date.now() + 14 * 24 * 3600000),
        visitorPhone: '+966502345678',
        visitorEmail: 'fatima@example.com'
      }
      // Add more leads as needed...
    ];

    const createdLeads = await Lead.bulkCreate(leads);
    console.log(`✅ Created ${createdLeads.length} leads`);

    // ========== Summary ==========
    console.log('\n✅ All demo data setup complete!');
    console.log('\n📊 Summary:');
    console.log(`   👤 Visitor Account:`);
    console.log(`      Email: visitor@demo.com`);
    console.log(`      SmartCardID: SmartCard#1200`);
    console.log(`      Password: demo123`);
    console.log(`      Contacts: ${createdContacts.length}`);
    console.log(`      Notes: ${createdNotes.length}`);
    console.log(`      FollowUps: ${createdFollowUps.length}`);
    console.log(`   👤 Exhibitor Account:`);
    console.log(`      Email: exhibitor@demo.com`);
    console.log(`      SmartCardID: SmartCard#2048`);
    console.log(`      Password: demo123`);
    console.log(`      Leads: ${createdLeads.length}`);

    process.exit(0);
  } catch (error) {
    console.error('❌ Error setting up demo accounts:', error);
    process.exit(1);
  }
}

// Run the script
setupDemoAccounts();

