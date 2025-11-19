const { sequelize } = require('../config/database');
const { User, Contact, Note, FollowUp, Lead } = require('../models');

/**
 * Add default demo data for visitor and exhibitor accounts
 */
async function addDemoData() {
  try {
    await sequelize.authenticate();
    console.log('✅ Connected to database');

    // Get demo user IDs
    const visitorUser = await User.findOne({ where: { email: 'visitor@demo.com' } });
    const exhibitorUser = await User.findOne({ where: { email: 'exhibitor@demo.com' } });

    if (!visitorUser) {
      console.error('❌ Visitor demo account not found!');
      process.exit(1);
    }

    if (!exhibitorUser) {
      console.error('❌ Exhibitor demo account not found!');
      process.exit(1);
    }

    console.log(`✅ Found visitor: ${visitorUser.expoId} (${visitorUser.id})`);
    console.log(`✅ Found exhibitor: ${exhibitorUser.expoId} (${exhibitorUser.id})`);

    // Clear existing data for demo accounts
    console.log('\n🗑️  Clearing existing demo data...');
    await Contact.destroy({ where: { userId: visitorUser.id } });
    await Note.destroy({ where: { userId: visitorUser.id } });
    await FollowUp.destroy({ where: { userId: visitorUser.id } });
    await Lead.destroy({ where: { exhibitorId: exhibitorUser.id } });
    console.log('✅ Cleared existing data');

    // Add Contacts for Visitor (22 contacts)
    console.log('\n📇 Adding 22 contacts for visitor...');
    const contacts = [
      {
        userId: visitorUser.id,
        name: 'أحمد محمد',
        companyName: 'نقل بلس',
        expoId: 'SmartCard#2048',
        category: 'نقل',
        booth: 'B12',
        description: 'تطبيق نقل طلاب - حلول ذكية للنقل المدرسي. شركة رائدة في مجال النقل الذكي. تقدم خدمات نقل آمنة ومريحة للطلاب مع تتبع مباشر.',
        scannedAt: new Date(Date.now() - 2 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501111111',
        email: 'info@naqlplus.com',
        website: 'www.naqlplus.com',
        brochure: {
          title: 'حلول النقل الذكي للمدارس',
          description: 'نقدم حلول نقل متكاملة وآمنة للمدارس مع تتبع مباشر للطلاب وأولياء الأمور. نظام ذكي يوفر الأمان والراحة للجميع.',
          features: ['تتبع مباشر للطلاب', 'إشعارات فورية', 'تقارير يومية', 'دعم 24/7', 'تطبيق موبايل', 'نظام إدارة متكامل'],
          services: ['نقل مدرسي', 'رحلات تعليمية', 'نقل طوارئ', 'نقل موظفين']
        }
      },
      {
        userId: visitorUser.id,
        name: 'سارة علي',
        companyName: 'تقنيات التعليم',
        expoId: 'SmartCard#3056',
        category: 'تعليم',
        booth: 'A5',
        description: 'حلول تعليمية ذكية ومنصات تعليم إلكتروني. منصات تفاعلية للتعلم عن بُعد مع محتوى تعليمي متقدم.',
        scannedAt: new Date(Date.now() - 5 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502222222',
        email: 'contact@edutech.com',
        website: 'www.edutech.com',
        brochure: {
          title: 'منصات التعليم الإلكتروني',
          description: 'حلول تعليمية متكاملة تجمع بين التقنية والتعليم لتحقيق أفضل النتائج.',
          features: ['فصول افتراضية', 'محتوى تفاعلي', 'تقييم تلقائي', 'تقارير شاملة'],
          services: ['منصات تعليمية', 'تدريب المعلمين', 'استشارات تعليمية']
        }
      },
      {
        userId: visitorUser.id,
        name: 'خالد سعيد',
        companyName: 'استثمارات المستقبل',
        expoId: 'SmartCard#4123',
        category: 'استثمار',
        booth: 'C8',
        description: 'شركة استثمارية متخصصة في قطاع التعليم والتقنية. تمويل المشاريع الناشئة والشركات التقنية.',
        scannedAt: new Date(Date.now() - 24 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966503333333',
        email: 'invest@future.com',
        website: 'www.future-invest.com'
      },
      {
        userId: visitorUser.id,
        name: 'ليلى حسن',
        companyName: 'منصة التعلم الذكي',
        expoId: 'SmartCard#5200',
        category: 'تعليم',
        booth: 'D15',
        description: 'منصة تعليمية متكاملة مع AI. محتوى تعليمي تفاعلي للطلاب والمعلمين مع تحليلات ذكية.',
        scannedAt: new Date(Date.now() - 3 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966504444444',
        email: 'hello@smartlearn.com',
        website: 'www.smartlearn.com'
      },
      {
        userId: visitorUser.id,
        name: 'محمد العلي',
        companyName: 'حلول الأمن السيبراني',
        expoId: 'SmartCard#6100',
        category: 'تقنية',
        booth: 'E20',
        description: 'حلول أمنية متقدمة للمؤسسات التعليمية. حماية البيانات والأنظمة من التهديدات السيبرانية.',
        scannedAt: new Date(Date.now() - 4 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966505555555',
        email: 'security@cybersolutions.com',
        website: 'www.cybersolutions.com'
      },
      {
        userId: visitorUser.id,
        name: 'فاطمة أحمد',
        companyName: 'مكتبة رقمية',
        expoId: 'SmartCard#7200',
        category: 'تعليم',
        booth: 'F10',
        description: 'مكتبة رقمية شاملة للكتب والمصادر التعليمية. آلاف الكتب والمراجع في مختلف المجالات.',
        scannedAt: new Date(Date.now() - 6 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966506666666',
        email: 'info@digitallib.com',
        website: 'www.digitallib.com'
      },
      {
        userId: visitorUser.id,
        name: 'عبدالله خالد',
        companyName: 'أنظمة إدارة المدارس',
        expoId: 'SmartCard#8300',
        category: 'تعليم',
        booth: 'G5',
        description: 'أنظمة إدارة متكاملة للمدارس. إدارة الطلاب والمعلمين والمناهج والتقارير.',
        scannedAt: new Date(Date.now() - 1 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966507777777',
        email: 'admin@schoolsys.com',
        website: 'www.schoolsys.com'
      },
      {
        userId: visitorUser.id,
        name: 'نورا سليمان',
        companyName: 'تطبيقات الواقع المعزز',
        expoId: 'SmartCard#9400',
        category: 'تقنية',
        booth: 'H12',
        description: 'تطبيقات تعليمية باستخدام الواقع المعزز. تجربة تعليمية تفاعلية ثلاثية الأبعاد.',
        scannedAt: new Date(Date.now() - 7 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966508888888',
        email: 'ar@edutech.com',
        website: 'www.ar-edu.com'
      },
      {
        userId: visitorUser.id,
        name: 'يوسف علي',
        companyName: 'شبكات الاتصال التعليمية',
        expoId: 'SmartCard#1050',
        category: 'تقنية',
        booth: 'I8',
        description: 'شبكات اتصال متخصصة للمؤسسات التعليمية. حلول اتصال آمنة وسريعة.',
        scannedAt: new Date(Date.now() - 2 * 24 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966509999999',
        email: 'network@educom.com',
        website: 'www.educom.com'
      },
      {
        userId: visitorUser.id,
        name: 'ريم محمد',
        companyName: 'منصة التدريب المهني',
        expoId: 'SmartCard#1160',
        category: 'تعليم',
        booth: 'J15',
        description: 'منصة تدريب مهني متخصصة. برامج تدريبية احترافية في مختلف المجالات.',
        scannedAt: new Date(Date.now() - 8 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966500000000',
        email: 'training@proplatform.com',
        website: 'www.proplatform.com'
      },
      {
        userId: visitorUser.id,
        name: 'خالد العتيبي',
        companyName: 'أكاديمية البرمجة',
        expoId: 'SmartCard#1270',
        category: 'تعليم',
        booth: 'K20',
        description: 'أكاديمية متخصصة في تعليم البرمجة للأطفال والشباب. دورات تفاعلية ومشاريع عملية.',
        scannedAt: new Date(Date.now() - 9 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501111222',
        email: 'info@codeacademy.com',
        website: 'www.codeacademy.com'
      },
      {
        userId: visitorUser.id,
        name: 'لينا القحطاني',
        companyName: 'منصة الاختبارات الإلكترونية',
        expoId: 'SmartCard#1380',
        category: 'تعليم',
        booth: 'L10',
        description: 'منصة متكاملة لإجراء الاختبارات الإلكترونية. تقييم تلقائي وتقارير شاملة.',
        scannedAt: new Date(Date.now() - 10 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502222333',
        email: 'exams@edutest.com',
        website: 'www.edutest.com'
      },
      {
        userId: visitorUser.id,
        name: 'فيصل المطيري',
        companyName: 'حلول التخزين السحابي',
        expoId: 'SmartCard#1490',
        category: 'تقنية',
        booth: 'M5',
        description: 'حلول تخزين سحابي آمنة للمؤسسات التعليمية. نسخ احتياطي تلقائي ووصول من أي مكان.',
        scannedAt: new Date(Date.now() - 11 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966503333444',
        email: 'cloud@edustorage.com',
        website: 'www.edustorage.com'
      },
      {
        userId: visitorUser.id,
        name: 'مها الشمري',
        companyName: 'أنظمة الحضور الذكية',
        expoId: 'SmartCard#1500',
        category: 'تقنية',
        booth: 'N12',
        description: 'أنظمة حضور ذكية باستخدام QR Code. تتبع تلقائي وإشعارات فورية.',
        scannedAt: new Date(Date.now() - 12 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966504444555',
        email: 'attendance@smartsys.com',
        website: 'www.smartsys.com'
      },
      {
        userId: visitorUser.id,
        name: 'بندر الدوسري',
        companyName: 'روبوتات التعليم',
        expoId: 'SmartCard#1610',
        category: 'تقنية',
        booth: 'O8',
        description: 'روبوتات تعليمية تفاعلية. تجربة تعليمية ممتعة ومبتكرة للأطفال.',
        scannedAt: new Date(Date.now() - 13 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966505555666',
        email: 'robots@edurobot.com',
        website: 'www.edurobot.com'
      },
      {
        userId: visitorUser.id,
        name: 'سارة العلي',
        companyName: 'تطبيقات الواقع الافتراضي',
        expoId: 'SmartCard#1720',
        category: 'تقنية',
        booth: 'P15',
        description: 'تطبيقات تعليمية باستخدام الواقع الافتراضي. رحلات افتراضية وتجارب تفاعلية.',
        scannedAt: new Date(Date.now() - 14 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966506666777',
        email: 'vr@eduvr.com',
        website: 'www.eduvr.com'
      },
      {
        userId: visitorUser.id,
        name: 'طارق الحمد',
        companyName: 'أنظمة الإدارة المالية',
        expoId: 'SmartCard#1830',
        category: 'إدارة',
        booth: 'Q20',
        description: 'أنظمة إدارة مالية متكاملة للمؤسسات التعليمية. محاسبة تلقائية وتقارير مالية.',
        scannedAt: new Date(Date.now() - 15 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966507777888',
        email: 'finance@edufin.com',
        website: 'www.edufin.com'
      },
      {
        userId: visitorUser.id,
        name: 'هند السالم',
        companyName: 'حلول الطباعة والنسخ',
        expoId: 'SmartCard#1940',
        category: 'خدمات',
        booth: 'R10',
        description: 'حلول طباعة ونسخ متخصصة للمؤسسات التعليمية. أجهزة حديثة وخدمات صيانة.',
        scannedAt: new Date(Date.now() - 16 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966508888999',
        email: 'print@edupress.com',
        website: 'www.edupress.com'
      },
      {
        userId: visitorUser.id,
        name: 'عمر النجار',
        companyName: 'استشارات تعليمية',
        expoId: 'SmartCard#2050',
        category: 'استشارات',
        booth: 'S5',
        description: 'استشارات تعليمية متخصصة. تطوير المناهج وتحسين الأداء التعليمي.',
        scannedAt: new Date(Date.now() - 17 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966509999000',
        email: 'consult@educonsult.com',
        website: 'www.educonsult.com'
      },
      {
        userId: visitorUser.id,
        name: 'ليلى القحطاني',
        companyName: 'منصة التواصل التعليمي',
        expoId: 'SmartCard#2160',
        category: 'تعليم',
        booth: 'T12',
        description: 'منصة تواصل متكاملة بين الطلاب والمعلمين وأولياء الأمور. رسائل وإشعارات فورية.',
        scannedAt: new Date(Date.now() - 18 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966500000111',
        email: 'comm@educomm.com',
        website: 'www.educomm.com'
      },
      {
        userId: visitorUser.id,
        name: 'ماجد العتيبي',
        companyName: 'حلول الطاقة الشمسية',
        expoId: 'SmartCard#2270',
        category: 'طاقة',
        booth: 'U8',
        description: 'حلول طاقة شمسية للمؤسسات التعليمية. توفير الطاقة وتقليل التكاليف.',
        scannedAt: new Date(Date.now() - 19 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501111222',
        email: 'solar@edusolar.com',
        website: 'www.edusolar.com'
      },
      {
        userId: visitorUser.id,
        name: 'نورة الشمري',
        companyName: 'أنظمة المكتبات الذكية',
        expoId: 'SmartCard#2380',
        category: 'تعليم',
        booth: 'V15',
        description: 'أنظمة مكتبات ذكية متكاملة. إدارة الكتب والاستعارات تلقائياً.',
        scannedAt: new Date(Date.now() - 20 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502222333',
        email: 'library@edulib.com',
        website: 'www.edulib.com'
      }
    ];

    const createdContacts = await Contact.bulkCreate(contacts);
    console.log(`✅ Created ${createdContacts.length} contacts`);

    // Add Notes for Visitor (15 notes)
    console.log('\n📝 Adding 15 notes for visitor...');
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
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[2].id,
        contactName: 'استثمارات المستقبل',
        contactExpoId: 'SmartCard#4123',
        content: 'فرصة استثمارية واعدة. يحتاج متابعة دقيقة.',
        createdAt: new Date(Date.now() - 3 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[3].id,
        contactName: 'منصة التعلم الذكي',
        contactExpoId: 'SmartCard#5200',
        content: 'منصة ذكية مع AI. تجربة ممتازة. يحتاج عرض توضيحي.',
        createdAt: new Date(Date.now() - 4 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[4].id,
        contactName: 'حلول الأمن السيبراني',
        contactExpoId: 'SmartCard#6100',
        content: 'حلول أمنية متقدمة. مهم جداً لحماية بياناتنا.',
        createdAt: new Date(Date.now() - 5 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[5].id,
        contactName: 'مكتبة رقمية',
        contactExpoId: 'SmartCard#7200',
        content: 'مكتبة رقمية شاملة. محتوى غني ومتنوع.',
        createdAt: new Date(Date.now() - 6 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[6].id,
        contactName: 'أنظمة إدارة المدارس',
        contactExpoId: 'SmartCard#8300',
        content: 'نظام إدارة متكامل. مناسب جداً لمدرستنا.',
        createdAt: new Date(Date.now() - 7 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[7].id,
        contactName: 'تطبيقات الواقع المعزز',
        contactExpoId: 'SmartCard#9400',
        content: 'تطبيقات AR ممتازة. تجربة تفاعلية رائعة.',
        createdAt: new Date(Date.now() - 8 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[8].id,
        contactName: 'شبكات الاتصال التعليمية',
        contactExpoId: 'SmartCard#1050',
        content: 'شبكة اتصال قوية. حل مناسب لاحتياجاتنا.',
        createdAt: new Date(Date.now() - 9 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[9].id,
        contactName: 'منصة التدريب المهني',
        contactExpoId: 'SmartCard#1160',
        content: 'منصة تدريب احترافية. برامج متنوعة.',
        createdAt: new Date(Date.now() - 10 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[10].id,
        contactName: 'أكاديمية البرمجة',
        contactExpoId: 'SmartCard#1270',
        content: 'أكاديمية ممتازة. دورات تفاعلية.',
        createdAt: new Date(Date.now() - 11 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[11].id,
        contactName: 'منصة الاختبارات الإلكترونية',
        contactExpoId: 'SmartCard#1380',
        content: 'منصة اختبارات متكاملة. تقييم تلقائي.',
        createdAt: new Date(Date.now() - 12 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[12].id,
        contactName: 'حلول التخزين السحابي',
        contactExpoId: 'SmartCard#1490',
        content: 'حل تخزين سحابي آمن. نسخ احتياطي تلقائي.',
        createdAt: new Date(Date.now() - 13 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[13].id,
        contactName: 'أنظمة الحضور الذكية',
        contactExpoId: 'SmartCard#1500',
        content: 'نظام حضور ذكي. تتبع تلقائي.',
        createdAt: new Date(Date.now() - 14 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[14].id,
        contactName: 'روبوتات التعليم',
        contactExpoId: 'SmartCard#1610',
        content: 'روبوتات تعليمية تفاعلية. تجربة ممتعة.',
        createdAt: new Date(Date.now() - 15 * 24 * 3600000)
      }
    ];

    const createdNotes = await Note.bulkCreate(notes);
    console.log(`✅ Created ${createdNotes.length} notes`);

    // Add FollowUps for Visitor (15 follow-ups)
    console.log('\n📅 Adding 15 follow-ups for visitor...');
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
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[2].id,
        contactName: 'استثمارات المستقبل',
        contactExpoId: 'SmartCard#4123',
        followUpDate: new Date(Date.now() + 10 * 24 * 3600000),
        note: 'متابعة فرص الاستثمار',
        isCompleted: false,
        createdAt: new Date(Date.now() - 2 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[3].id,
        contactName: 'منصة التعلم الذكي',
        contactExpoId: 'SmartCard#5200',
        followUpDate: new Date(Date.now() + 5 * 24 * 3600000),
        note: 'عرض توضيحي للمنصة',
        isCompleted: false,
        createdAt: new Date(Date.now() - 3 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[4].id,
        contactName: 'حلول الأمن السيبراني',
        contactExpoId: 'SmartCard#6100',
        followUpDate: new Date(Date.now() + 6 * 24 * 3600000),
        note: 'مناقشة الحلول الأمنية',
        isCompleted: false,
        createdAt: new Date(Date.now() - 4 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[5].id,
        contactName: 'مكتبة رقمية',
        contactExpoId: 'SmartCard#7200',
        followUpDate: new Date(Date.now() + 4 * 24 * 3600000),
        note: 'عرض المكتبة الرقمية',
        isCompleted: false,
        createdAt: new Date(Date.now() - 6 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[6].id,
        contactName: 'أنظمة إدارة المدارس',
        contactExpoId: 'SmartCard#8300',
        followUpDate: new Date(Date.now() + 8 * 24 * 3600000),
        note: 'عرض الأنظمة',
        isCompleted: false,
        createdAt: new Date(Date.now() - 1 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[7].id,
        contactName: 'تطبيقات الواقع المعزز',
        contactExpoId: 'SmartCard#9400',
        followUpDate: new Date(Date.now() + 9 * 24 * 3600000),
        note: 'تجربة التطبيقات',
        isCompleted: false,
        createdAt: new Date(Date.now() - 7 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[8].id,
        contactName: 'شبكات الاتصال التعليمية',
        contactExpoId: 'SmartCard#1050',
        followUpDate: new Date(Date.now() - 1 * 24 * 3600000),
        note: 'مكالمة متابعة',
        isCompleted: true,
        completedAt: new Date(Date.now() - 2 * 3600000),
        createdAt: new Date(Date.now() - 2 * 24 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[9].id,
        contactName: 'منصة التدريب المهني',
        contactExpoId: 'SmartCard#1160',
        followUpDate: new Date(Date.now() + 11 * 24 * 3600000),
        note: 'عرض المنصة',
        isCompleted: false,
        createdAt: new Date(Date.now() - 8 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[10].id,
        contactName: 'أكاديمية البرمجة',
        contactExpoId: 'SmartCard#1270',
        followUpDate: new Date(Date.now() + 12 * 24 * 3600000),
        note: 'عرض الأكاديمية',
        isCompleted: false,
        createdAt: new Date(Date.now() - 9 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[11].id,
        contactName: 'منصة الاختبارات الإلكترونية',
        contactExpoId: 'SmartCard#1380',
        followUpDate: new Date(Date.now() + 13 * 24 * 3600000),
        note: 'عرض المنصة',
        isCompleted: false,
        createdAt: new Date(Date.now() - 10 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[12].id,
        contactName: 'حلول التخزين السحابي',
        contactExpoId: 'SmartCard#1490',
        followUpDate: new Date(Date.now() + 14 * 24 * 3600000),
        note: 'عرض الحلول',
        isCompleted: false,
        createdAt: new Date(Date.now() - 11 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[13].id,
        contactName: 'أنظمة الحضور الذكية',
        contactExpoId: 'SmartCard#1500',
        followUpDate: new Date(Date.now() + 15 * 24 * 3600000),
        note: 'عرض الأنظمة',
        isCompleted: false,
        createdAt: new Date(Date.now() - 12 * 3600000)
      },
      {
        userId: visitorUser.id,
        contactId: createdContacts[14].id,
        contactName: 'روبوتات التعليم',
        contactExpoId: 'SmartCard#1610',
        followUpDate: new Date(Date.now() + 16 * 24 * 3600000),
        note: 'تجربة الروبوتات',
        isCompleted: false,
        createdAt: new Date(Date.now() - 13 * 3600000)
      }
    ];

    const createdFollowUps = await FollowUp.bulkCreate(followUps);
    console.log(`✅ Created ${createdFollowUps.length} follow-ups`);

    // Add Leads for Exhibitor (25 leads)
    console.log('\n🎯 Adding 25 leads for exhibitor...');
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
        notes: 'مهتم جداً بتطبيق نقل الطلاب. طلب عرض توضيحي خلال أسبوع. لديه 50 مدرسة كعميل محتمل.',
        followUpDate: new Date(Date.now() + 7 * 24 * 3600000),
        visitorPhone: '+966501234567',
        visitorEmail: 'mohammed@example.com'
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
        notes: 'مهتم بشراكة تنفيذية. مناقشة استخدام تطبيق سمستر. متابعة بعد أسبوعين.',
        followUpDate: new Date(Date.now() + 14 * 24 * 3600000),
        visitorPhone: '+966502345678',
        visitorEmail: 'fatima@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'خالد سعيد',
        visitorExpoId: 'SmartCard#1400',
        scannedAt: new Date(Date.now() - 8 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'contacted',
        aiScore: 68,
        notes: 'تم التواصل. يبحث عن حلول نقل للمدارس.',
        followUpDate: new Date(Date.now() + 5 * 24 * 3600000),
        visitorPhone: '+966503456789',
        visitorEmail: 'khalid@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'عبدالله محمد',
        visitorExpoId: 'SmartCard#1500',
        scannedAt: new Date(Date.now() - 12 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 79,
        notes: 'مهتم جداً. لديه شبكة مدارس واسعة.',
        followUpDate: new Date(Date.now() + 3 * 24 * 3600000),
        visitorPhone: '+966504567890',
        visitorEmail: 'abdullah@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'نورا العلي',
        visitorExpoId: 'SmartCard#1600',
        scannedAt: new Date(Date.now() - 15 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'new',
        aiScore: 65,
        notes: 'زائر جديد. مهتم بالحلول.',
        followUpDate: new Date(Date.now() + 6 * 24 * 3600000),
        visitorPhone: '+966505678901',
        visitorEmail: 'nora@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'يوسف خالد',
        visitorExpoId: 'SmartCard#1700',
        scannedAt: new Date(Date.now() - 18 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'follow-up',
        aiScore: 71,
        notes: 'متابعة عرض الأسعار.',
        followUpDate: new Date(Date.now() + 8 * 24 * 3600000),
        visitorPhone: '+966506789012',
        visitorEmail: 'youssef@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'ريم سليمان',
        visitorExpoId: 'SmartCard#1800',
        scannedAt: new Date(Date.now() - 20 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 82,
        notes: 'مهتمة جداً. طلبت عرض توضيحي شامل.',
        followUpDate: new Date(Date.now() + 4 * 24 * 3600000),
        visitorPhone: '+966507890123',
        visitorEmail: 'reem@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'خالد القحطاني',
        visitorExpoId: 'SmartCard#1900',
        scannedAt: new Date(Date.now() - 24 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'contacted',
        aiScore: 76,
        notes: 'تم التواصل. مناقشة التفاصيل.',
        followUpDate: new Date(Date.now() + 9 * 24 * 3600000),
        visitorPhone: '+966508901234',
        visitorEmail: 'khalid2@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'لينا الشمري',
        visitorExpoId: 'SmartCard#2000',
        scannedAt: new Date(Date.now() - 28 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 88,
        notes: 'مهتمة جداً. لديها 30 مدرسة.',
        followUpDate: new Date(Date.now() + 2 * 24 * 3600000),
        visitorPhone: '+966509012345',
        visitorEmail: 'lina@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'فيصل المطيري',
        visitorExpoId: 'SmartCard#2100',
        scannedAt: new Date(Date.now() - 32 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'follow-up',
        aiScore: 73,
        notes: 'متابعة عرض الأسعار. تنتظر الرد.',
        followUpDate: new Date(Date.now() + 10 * 24 * 3600000),
        visitorPhone: '+966500123456',
        visitorEmail: 'faisal@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'مها العتيبي',
        visitorExpoId: 'SmartCard#2200',
        scannedAt: new Date(Date.now() - 36 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'new',
        aiScore: 60,
        notes: 'زائر جديد. يحتاج متابعة.',
        followUpDate: new Date(Date.now() + 11 * 24 * 3600000),
        visitorPhone: '+966501234567',
        visitorEmail: 'maha@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'بندر الدوسري',
        visitorExpoId: 'SmartCard#2300',
        scannedAt: new Date(Date.now() - 40 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'contacted',
        aiScore: 69,
        notes: 'تم التواصل. مهتم بالحلول.',
        followUpDate: new Date(Date.now() + 12 * 24 * 3600000),
        visitorPhone: '+966502345678',
        visitorEmail: 'bandar@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'سارة القحطاني',
        visitorExpoId: 'SmartCard#2400',
        scannedAt: new Date(Date.now() - 44 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 81,
        notes: 'مهتمة جداً. طلبت عرض توضيحي.',
        followUpDate: new Date(Date.now() + 13 * 24 * 3600000),
        visitorPhone: '+966503456789',
        visitorEmail: 'sara2@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'طارق الحمد',
        visitorExpoId: 'SmartCard#2500',
        scannedAt: new Date(Date.now() - 48 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'follow-up',
        aiScore: 74,
        notes: 'متابعة عرض الأسعار.',
        followUpDate: new Date(Date.now() + 14 * 24 * 3600000),
        visitorPhone: '+966504567890',
        visitorEmail: 'tariq@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'هند السالم',
        visitorExpoId: 'SmartCard#2600',
        scannedAt: new Date(Date.now() - 52 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'new',
        aiScore: 58,
        notes: 'زائر جديد. يحتاج متابعة.',
        followUpDate: new Date(Date.now() + 15 * 24 * 3600000),
        visitorPhone: '+966505678901',
        visitorEmail: 'hind@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'عمر النجار',
        visitorExpoId: 'SmartCard#2700',
        scannedAt: new Date(Date.now() - 56 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'contacted',
        aiScore: 67,
        notes: 'تم التواصل. مناقشة التفاصيل.',
        followUpDate: new Date(Date.now() + 16 * 24 * 3600000),
        visitorPhone: '+966506789012',
        visitorEmail: 'omar@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'ليلى القحطاني',
        visitorExpoId: 'SmartCard#2800',
        scannedAt: new Date(Date.now() - 60 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 84,
        notes: 'مهتمة جداً. لديها شبكة مدارس.',
        followUpDate: new Date(Date.now() + 17 * 24 * 3600000),
        visitorPhone: '+966507890123',
        visitorEmail: 'layla@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'ماجد العتيبي',
        visitorExpoId: 'SmartCard#2900',
        scannedAt: new Date(Date.now() - 64 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'follow-up',
        aiScore: 70,
        notes: 'متابعة عرض الأسعار.',
        followUpDate: new Date(Date.now() + 18 * 24 * 3600000),
        visitorPhone: '+966508901234',
        visitorEmail: 'majed@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'نورة الشمري',
        visitorExpoId: 'SmartCard#3000',
        scannedAt: new Date(Date.now() - 68 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'new',
        aiScore: 62,
        notes: 'زائر جديد. يحتاج متابعة.',
        followUpDate: new Date(Date.now() + 19 * 24 * 3600000),
        visitorPhone: '+966509012345',
        visitorEmail: 'noura@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'عبدالله السالم',
        visitorExpoId: 'SmartCard#3100',
        scannedAt: new Date(Date.now() - 72 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'contacted',
        aiScore: 75,
        notes: 'تم التواصل. مهتم بالحلول.',
        followUpDate: new Date(Date.now() + 20 * 24 * 3600000),
        visitorPhone: '+966500123456',
        visitorEmail: 'abdullah2@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'سلمى الدوسري',
        visitorExpoId: 'SmartCard#3200',
        scannedAt: new Date(Date.now() - 76 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 86,
        notes: 'مهتمة جداً. طلبت عرض توضيحي شامل.',
        followUpDate: new Date(Date.now() + 21 * 24 * 3600000),
        visitorPhone: '+966501234567',
        visitorEmail: 'salma@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'يوسف المطيري',
        visitorExpoId: 'SmartCard#3300',
        scannedAt: new Date(Date.now() - 80 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'follow-up',
        aiScore: 77,
        notes: 'متابعة عرض الأسعار.',
        followUpDate: new Date(Date.now() + 22 * 24 * 3600000),
        visitorPhone: '+966502345678',
        visitorEmail: 'youssef2@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'ريم القحطاني',
        visitorExpoId: 'SmartCard#3400',
        scannedAt: new Date(Date.now() - 84 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'contacted',
        aiScore: 79,
        notes: 'تم التواصل. مهتم بالحلول.',
        followUpDate: new Date(Date.now() + 23 * 24 * 3600000),
        visitorPhone: '+966503456789',
        visitorEmail: 'reem2@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'خالد الشمري',
        visitorExpoId: 'SmartCard#3500',
        scannedAt: new Date(Date.now() - 88 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'interested',
        aiScore: 83,
        notes: 'مهتم جداً. طلب عرض توضيحي.',
        followUpDate: new Date(Date.now() + 24 * 24 * 3600000),
        visitorPhone: '+966504567890',
        visitorEmail: 'khalid3@example.com'
      },
      {
        exhibitorId: exhibitorUser.id,
        visitorId: visitorUser.id,
        visitorName: 'لينا العتيبي',
        visitorExpoId: 'SmartCard#3600',
        scannedAt: new Date(Date.now() - 92 * 3600000),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        status: 'follow-up',
        aiScore: 71,
        notes: 'متابعة عرض الأسعار. تنتظر الرد.',
        followUpDate: new Date(Date.now() + 25 * 24 * 3600000),
        visitorPhone: '+966505678901',
        visitorEmail: 'lina2@example.com'
      }
    ];

    const createdLeads = await Lead.bulkCreate(leads);
    console.log(`✅ Created ${createdLeads.length} leads`);

    console.log('\n✅ All demo data added successfully!');
    console.log('\n📊 Summary:');
    console.log(`   - Visitor Contacts: ${createdContacts.length}`);
    console.log(`   - Visitor Notes: ${createdNotes.length}`);
    console.log(`   - Visitor FollowUps: ${createdFollowUps.length}`);
    console.log(`   - Exhibitor Leads: ${createdLeads.length}`);

    process.exit(0);
  } catch (error) {
    console.error('❌ Error adding demo data:', error);
    process.exit(1);
  }
}

// Run the script
addDemoData();

