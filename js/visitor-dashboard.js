// Visitor Dashboard JavaScript

// تحميل البيانات من localStorage (إذا كانت موجودة)
let contacts = JSON.parse(localStorage.getItem('contacts') || '[]');
let notes = JSON.parse(localStorage.getItem('notes') || '[]');
let followUps = JSON.parse(localStorage.getItem('followUps') || '[]');
// currentUser - تحميل من localStorage مباشرة
let currentUser = JSON.parse(localStorage.getItem('currentUser') || '{}');

// Sample default data for demo - بيانات تفصيلية وواقعية
// هذه جهات اتصال من عارضين قابلتهم في المعرض
// كل جهة اتصال تمثل لقاء حقيقي - الزائر مسح QR code العارض
const sampleContacts = [
    {
        id: '1',
        name: 'أحمد محمد',
        companyName: 'نقل بلس',
        expoId: 'Expo#2048',
        category: 'نقل',
        booth: 'B12',
        description: 'تطبيق نقل طلاب - حلول ذكية للنقل المدرسي. شركة رائدة في مجال النقل الذكي. تقدم خدمات نقل آمنة ومريحة للطلاب مع تتبع مباشر.',
        scannedAt: new Date(Date.now() - 2 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501111111',
        email: 'info@naqlplus.com',
        website: 'www.naqlplus.com',
        brochure: {
            title: 'حلول النقل الذكي للمدارس',
            description: 'نقدم حلول نقل متكاملة وآمنة للمدارس مع تتبع مباشر للطلاب وأولياء الأمور. نظام ذكي يوفر الأمان والراحة للجميع.',
            features: ['تتبع مباشر للطلاب', 'إشعارات فورية', 'تقارير يومية', 'دعم 24/7', 'تطبيق موبايل', 'نظام إدارة متكامل'],
            services: ['نقل مدرسي', 'رحلات تعليمية', 'نقل طوارئ', 'نقل موظفين'],
            brochureUrl: '#'
        }
    },
    {
        id: '2',
        name: 'سارة علي',
        companyName: 'تقنيات التعليم',
        expoId: 'Expo#3056',
        category: 'تعليم',
        booth: 'A5',
        description: 'حلول تعليمية ذكية ومنصات تعليم إلكتروني. منصات تفاعلية للتعلم عن بُعد مع محتوى تعليمي متقدم.',
        scannedAt: new Date(Date.now() - 5 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502222222',
        email: 'contact@edutech.com',
        website: 'www.edutech.com',
        brochure: {
            title: 'منصات التعليم الإلكتروني',
            description: 'حلول تعليمية متكاملة تجمع بين التقنية والتعليم لتحقيق أفضل النتائج. منصات تفاعلية تجعل التعلم أكثر متعة وفعالية.',
            features: ['فصول افتراضية', 'محتوى تفاعلي', 'تقييم تلقائي', 'تقارير شاملة', 'دعم متعدد اللغات', 'تكامل مع أنظمة المدارس'],
            services: ['منصات تعليمية', 'تدريب المعلمين', 'استشارات تعليمية', 'تطوير المحتوى'],
            brochureUrl: '#'
        }
    },
    {
        id: '3',
        name: 'خالد سعيد',
        companyName: 'استثمارات المستقبل',
        expoId: 'Expo#4123',
        category: 'استثمار',
        booth: 'C8',
        description: 'شركة استثمارية متخصصة في قطاع التعليم والتقنية. تمويل المشاريع الناشئة والشركات التقنية.',
        scannedAt: new Date(Date.now() - 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966503333333',
        email: 'invest@future.com',
        website: 'www.future-invest.com'
    },
    {
        id: '4',
        name: 'ليلى حسن',
        companyName: 'منصة التعلم الذكي',
        expoId: 'Expo#5200',
        category: 'تعليم',
        booth: 'D15',
        description: 'منصة تعليمية متكاملة مع AI. محتوى تعليمي تفاعلي للطلاب والمعلمين مع تحليلات ذكية.',
        scannedAt: new Date(Date.now() - 3 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966504444444',
        email: 'hello@smartlearn.com',
        website: 'www.smartlearn.com'
    },
    {
        id: '5',
        name: 'محمد العلي',
        companyName: 'حلول الأمن السيبراني',
        expoId: 'Expo#6100',
        category: 'تقنية',
        booth: 'E20',
        description: 'حلول أمنية متقدمة للمؤسسات التعليمية. حماية البيانات والأنظمة من التهديدات السيبرانية.',
        scannedAt: new Date(Date.now() - 4 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966505555555',
        email: 'security@cybersolutions.com',
        website: 'www.cybersolutions.com'
    },
    {
        id: '6',
        name: 'فاطمة الزهراني',
        companyName: 'مكتبة رقمية',
        expoId: 'Expo#7200',
        category: 'تعليم',
        booth: 'F8',
        description: 'مكتبة رقمية شاملة للكتب والمصادر التعليمية. آلاف الكتب الإلكترونية والمصادر التعليمية.',
        scannedAt: new Date(Date.now() - 6 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966506666666',
        email: 'info@digitallib.com',
        website: 'www.digitallib.com'
    },
    {
        id: '7',
        name: 'عبدالله القحطاني',
        companyName: 'أنظمة إدارة المدارس',
        expoId: 'Expo#8300',
        category: 'تعليم',
        booth: 'G12',
        description: 'أنظمة متكاملة لإدارة المدارس والطلاب. إدارة الحضور والغياب والدرجات والأنشطة.',
        scannedAt: new Date(Date.now() - 1 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966507777777',
        email: 'contact@schoolsys.com',
        website: 'www.schoolsys.com'
    },
    {
        id: '8',
        name: 'نورا السالم',
        companyName: 'تطبيقات الواقع المعزز',
        expoId: 'Expo#9400',
        category: 'تقنية',
        booth: 'H5',
        description: 'تطبيقات تعليمية باستخدام الواقع المعزز. تجارب تعليمية تفاعلية ثلاثية الأبعاد.',
        scannedAt: new Date(Date.now() - 7 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966508888888',
        email: 'ar@edutech.com',
        website: 'www.aredutech.com'
    },
    {
        id: '9',
        name: 'يوسف المطيري',
        companyName: 'شبكات الاتصال التعليمية',
        expoId: 'Expo#10500',
        category: 'تقنية',
        booth: 'I15',
        description: 'حلول شبكات متقدمة للمؤسسات التعليمية. بنية تحتية قوية للاتصال والإنترنت.',
        scannedAt: new Date(Date.now() - 2 * 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966509999999',
        email: 'networks@techsol.com',
        website: 'www.techsol.com'
    },
    {
        id: '10',
        name: 'ريم العتيبي',
        companyName: 'منصة التدريب المهني',
        expoId: 'Expo#11600',
        category: 'تعليم',
        booth: 'J8',
        description: 'منصة متخصصة في التدريب المهني والتطوير الوظيفي. دورات تدريبية معتمدة.',
        scannedAt: new Date(Date.now() - 8 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501010101',
        email: 'training@proplatform.com',
        website: 'www.proplatform.com'
    },
    {
        id: '11',
        name: 'طارق الحربي',
        companyName: 'حلول الطباعة التعليمية',
        expoId: 'Expo#12700',
        category: 'تعليم',
        booth: 'K12',
        description: 'حلول طباعة متخصصة للمؤسسات التعليمية. طابعات ثلاثية الأبعاد وطابعات متعددة الوظائف.',
        scannedAt: new Date(Date.now() - 3 * 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501111222',
        email: 'print@edusolutions.com',
        website: 'www.edusolutions.com'
    },
    {
        id: '12',
        name: 'هند الشمري',
        companyName: 'أنظمة الفصول الذكية',
        expoId: 'Expo#13800',
        category: 'تعليم',
        booth: 'L5',
        description: 'أنظمة فصول ذكية متكاملة. شاشات تفاعلية وأجهزة عرض متقدمة للتعليم.',
        scannedAt: new Date(Date.now() - 9 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501212121',
        email: 'smart@classroom.com',
        website: 'www.smartclassroom.com'
    },
    {
        id: '13',
        name: 'بدر الدوسري',
        companyName: 'تطبيقات الموبايل التعليمية',
        expoId: 'Expo#14900',
        category: 'تقنية',
        booth: 'M20',
        description: 'تطبيقات موبايل تعليمية للطلاب والمعلمين. تطبيقات تفاعلية للتعلم والمراجعة.',
        scannedAt: new Date(Date.now() - 10 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501313131',
        email: 'mobile@edutech.com',
        website: 'www.mobileedutech.com'
    },
    {
        id: '14',
        name: 'سعد العريفي',
        companyName: 'أنظمة الحضور الذكية',
        expoId: 'Expo#15000',
        category: 'تقنية',
        booth: 'N8',
        description: 'أنظمة حضور ذكية باستخدام البصمة والوجه. تتبع دقيق للحضور والغياب.',
        scannedAt: new Date(Date.now() - 4 * 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501414141',
        email: 'attendance@smart.com',
        website: 'www.smartattendance.com'
    },
    {
        id: '15',
        name: 'لينا الفهد',
        companyName: 'منصة الاختبارات الإلكترونية',
        expoId: 'Expo#16100',
        category: 'تعليم',
        booth: 'O15',
        description: 'منصة متكاملة للاختبارات الإلكترونية. إنشاء وتصحيح الاختبارات تلقائياً.',
        scannedAt: new Date(Date.now() - 11 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501515151',
        email: 'exams@edutest.com',
        website: 'www.edutest.com'
    },
    {
        id: '16',
        name: 'مشعل الغامدي',
        companyName: 'حلول التخزين السحابي',
        expoId: 'Expo#17200',
        category: 'تقنية',
        booth: 'P12',
        description: 'حلول تخزين سحابي آمنة للمؤسسات التعليمية. تخزين غير محدود للبيانات والملفات.',
        scannedAt: new Date(Date.now() - 5 * 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501616161',
        email: 'cloud@storage.com',
        website: 'www.cloudstorage.com'
    },
    {
        id: '17',
        name: 'داليا الخالدي',
        companyName: 'برامج الإرشاد الطلابي',
        expoId: 'Expo#18300',
        category: 'تعليم',
        booth: 'Q5',
        description: 'برامج متخصصة في الإرشاد الطلابي والتوجيه المهني. مساعدة الطلاب في اختيار التخصصات.',
        scannedAt: new Date(Date.now() - 12 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501717171',
        email: 'guidance@student.com',
        website: 'www.studentguidance.com'
    },
    {
        id: '18',
        name: 'عمر الزهراني',
        companyName: 'أنظمة المكتبات الرقمية',
        expoId: 'Expo#19400',
        category: 'تعليم',
        booth: 'R20',
        description: 'أنظمة إدارة مكتبات رقمية متقدمة. فهرسة وتصنيف وإدارة الكتب والمصادر.',
        scannedAt: new Date(Date.now() - 6 * 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501818181',
        email: 'library@digital.com',
        website: 'www.digitallibrary.com'
    },
    {
        id: '19',
        name: 'سلمى القحطاني',
        companyName: 'منصات التعليم المدمج',
        expoId: 'Expo#20500',
        category: 'تعليم',
        booth: 'S8',
        description: 'منصات تعليم مدمج تجمع بين التعليم التقليدي والإلكتروني. حلول متكاملة للتعلم الهجين.',
        scannedAt: new Date(Date.now() - 13 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966501919191',
        email: 'blended@learning.com',
        website: 'www.blendedlearning.com'
    },
    {
        id: '20',
        name: 'خالد المالكي',
        companyName: 'أنظمة الأمن والمراقبة',
        expoId: 'Expo#21600',
        category: 'تقنية',
        booth: 'T15',
        description: 'أنظمة أمن ومراقبة متقدمة للمؤسسات التعليمية. كاميرات ذكية وأنظمة إنذار.',
        scannedAt: new Date(Date.now() - 7 * 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502020202',
        email: 'security@monitor.com',
        website: 'www.securitymonitor.com'
    },
    {
        id: '21',
        name: 'نورة العتيبي',
        companyName: 'تطبيقات الواقع الافتراضي',
        expoId: 'Expo#22700',
        category: 'تقنية',
        booth: 'U12',
        description: 'تطبيقات تعليمية باستخدام الواقع الافتراضي. تجارب تعليمية غامرة للطلاب.',
        scannedAt: new Date(Date.now() - 14 * 3600000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502121212',
        email: 'vr@education.com',
        website: 'www.vreducation.com'
    },
    {
        id: '22',
        name: 'فهد الشمري',
        companyName: 'أنظمة إدارة الموارد البشرية',
        expoId: 'Expo#23800',
        category: 'تعليم',
        booth: 'V5',
        description: 'أنظمة إدارة موارد بشرية متخصصة للمؤسسات التعليمية. إدارة الموظفين والرواتب.',
        scannedAt: new Date(Date.now() - 8 * 86400000).toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024',
        phone: '+966502222222',
        email: 'hr@education.com',
        website: 'www.hreducation.com'
    }
];

const sampleNotes = [
    {
        id: '1',
        contactId: '1',
        contactName: 'نقل بلس',
        text: 'مناقشة استخدام تطبيق سمستر. مهتم بشراكة تنفيذية. طلب عرض توضيحي. متابعة بعد أسبوعين. الشركة لديها 500+ مدرسة كعميل.',
        createdAt: new Date(Date.now() - 2 * 3600000).toISOString()
    },
    {
        id: '2',
        contactId: '2',
        contactName: 'تقنيات التعليم',
        text: 'عرض منصة تعليمية متقدمة. حلول تفاعلية للتعلم عن بُعد. طلب عرض توضيحي خلال أسبوع. إمكانية تخصيص المنصة حسب احتياجاتنا.',
        createdAt: new Date(Date.now() - 5 * 3600000).toISOString()
    },
    {
        id: '3',
        contactId: '4',
        contactName: 'منصة التعلم الذكي',
        text: 'منصة رائعة مع AI. إمكانية دمج مع نظامنا. متابعة بعد المعرض. الممثل وعد بإرسال عرض مفصل.',
        createdAt: new Date(Date.now() - 3 * 3600000).toISOString()
    },
    {
        id: '4',
        contactId: '5',
        contactName: 'حلول الأمن السيبراني',
        text: 'حلول أمنية قوية. يحتاجون إلى قائمة باحتياجاتنا الأمنية. متابعة خلال 3 أيام.',
        createdAt: new Date(Date.now() - 4 * 3600000).toISOString()
    },
    {
        id: '5',
        contactId: '7',
        contactName: 'أنظمة إدارة المدارس',
        text: 'نظام شامل لإدارة المدارس. عرض توضيحي مطلوب. السعر معقول جداً. إمكانية تطبيق تجريبي.',
        createdAt: new Date(Date.now() - 1 * 3600000).toISOString()
    },
    {
        id: '6',
        contactId: '10',
        contactName: 'منصة التدريب المهني',
        text: 'منصة تدريب احترافية. دورات معتمدة. مهتمون بتدريب فريقنا. طلب قائمة بالدورات المتاحة.',
        createdAt: new Date(Date.now() - 8 * 3600000).toISOString()
    },
    {
        id: '7',
        contactId: '12',
        contactName: 'أنظمة الفصول الذكية',
        text: 'شاشات تفاعلية متقدمة. تجربة ممتازة. يحتاجون إلى قياس المساحات في فصولنا. متابعة بعد أسبوع.',
        createdAt: new Date(Date.now() - 9 * 3600000).toISOString()
    },
    {
        id: '8',
        contactId: '15',
        contactName: 'منصة الاختبارات الإلكترونية',
        text: 'منصة اختبارات متكاملة. سهولة الاستخدام. طلب عرض تجريبي. السعر مناسب للميزانية.',
        createdAt: new Date(Date.now() - 11 * 3600000).toISOString()
    },
    {
        id: '9',
        contactId: '19',
        contactName: 'منصات التعليم المدمج',
        text: 'حل مثالي للتعليم الهجين. يجمع بين التقليدي والإلكتروني. طلب عرض تفصيلي مع الأسعار.',
        createdAt: new Date(Date.now() - 13 * 3600000).toISOString()
    },
    {
        id: '10',
        contactId: '21',
        contactName: 'تطبيقات الواقع الافتراضي',
        text: 'تقنية متقدمة جداً. تجربة غامرة. يحتاجون إلى معرفة عدد الطلاب المستهدفين. متابعة خلال أسبوعين.',
        createdAt: new Date(Date.now() - 14 * 3600000).toISOString()
    }
];

const sampleFollowUps = [
    {
        id: '1',
        contactId: '1',
        contactName: 'نقل بلس',
        date: new Date(Date.now() + 14 * 86400000).toISOString(),
        period: '2weeks',
        createdAt: new Date(Date.now() - 2 * 3600000).toISOString(),
        note: 'متابعة مناقشة الشراكة التنفيذية'
    },
    {
        id: '2',
        contactId: '2',
        contactName: 'تقنيات التعليم',
        date: new Date(Date.now() + 7 * 86400000).toISOString(),
        period: '1week',
        createdAt: new Date(Date.now() - 5 * 3600000).toISOString(),
        note: 'عرض توضيحي للمنصة التعليمية'
    },
    {
        id: '3',
        contactId: '5',
        contactName: 'حلول الأمن السيبراني',
        date: new Date(Date.now() + 3 * 86400000).toISOString(),
        period: '3days',
        createdAt: new Date(Date.now() - 4 * 3600000).toISOString(),
        note: 'متابعة قائمة الاحتياجات الأمنية'
    },
    {
        id: '4',
        contactId: '7',
        contactName: 'أنظمة إدارة المدارس',
        date: new Date(Date.now() + 5 * 86400000).toISOString(),
        period: '1week',
        createdAt: new Date(Date.now() - 1 * 3600000).toISOString(),
        note: 'متابعة العرض التوضيحي'
    },
    {
        id: '5',
        contactId: '10',
        contactName: 'منصة التدريب المهني',
        date: new Date(Date.now() + 10 * 86400000).toISOString(),
        period: '1week',
        createdAt: new Date(Date.now() - 8 * 3600000).toISOString(),
        note: 'متابعة قائمة الدورات'
    },
    {
        id: '6',
        contactId: '12',
        contactName: 'أنظمة الفصول الذكية',
        date: new Date(Date.now() + 7 * 86400000).toISOString(),
        period: '1week',
        createdAt: new Date(Date.now() - 9 * 3600000).toISOString(),
        note: 'متابعة قياس المساحات'
    },
    {
        id: '7',
        contactId: '15',
        contactName: 'منصة الاختبارات الإلكترونية',
        date: new Date(Date.now() + 4 * 86400000).toISOString(),
        period: '3days',
        createdAt: new Date(Date.now() - 11 * 3600000).toISOString(),
        note: 'متابعة العرض التجريبي'
    },
    {
        id: '8',
        contactId: '19',
        contactName: 'منصات التعليم المدمج',
        date: new Date(Date.now() + 6 * 86400000).toISOString(),
        period: '1week',
        createdAt: new Date(Date.now() - 13 * 3600000).toISOString(),
        note: 'متابعة العرض التفصيلي'
    }
];

// Initialize Dashboard
document.addEventListener('DOMContentLoaded', function() {
    // إنشاء مستخدم افتراضي للزائر إذا لم يكن موجوداً (للتجربة بدون تسجيل)
    if (!currentUser || !currentUser.id || currentUser.role !== 'visitor') {
        currentUser = {
            id: 'visitor-demo',
            expoId: 'Expo#1200',
            name: 'زائر تجريبي',
            email: 'visitor@demo.com',
            phone: '+966501234567',
            role: 'visitor',
            interests: ['تعليم', 'نقل', 'تقنية'],
            createdAt: new Date().toISOString()
        };
        localStorage.setItem('currentUser', JSON.stringify(currentUser));
    }
    
    // Set ExpoID
    const expoIdElement = document.getElementById('userExpoId');
    if (expoIdElement && currentUser.expoId) {
        expoIdElement.textContent = currentUser.expoId;
    }
    
    // Load default data automatically for demo - إجبارياً
    // البيانات الافتراضية تظهر تلقائياً لمحاكاة تجربة المعرض الحقيقية
    // هذه محاكاة واقعية - الزائر قابل 22 عارض في المعرض
    
    console.log('بدء تحميل لوحة تحكم الزائر...');
    
    // تحميل البيانات الافتراضية إجبارياً للتجربة
    contacts = [...sampleContacts];
    notes = [...sampleNotes];
    followUps = [...sampleFollowUps];
    
    // حفظ البيانات في localStorage
    localStorage.setItem('contacts', JSON.stringify(contacts));
    localStorage.setItem('notes', JSON.stringify(notes));
    localStorage.setItem('followUps', JSON.stringify(followUps));
    
    console.log('✅ تم تحميل البيانات الافتراضية:');
    console.log('  - جهات اتصال:', contacts.length);
    console.log('  - ملاحظات:', notes.length);
    console.log('  - متابعات:', followUps.length);
    
    // Load data - تأكد من تحميل البيانات
    setTimeout(() => {
        console.log('بدء عرض البيانات...');
        loadContacts();
        loadNotes();
        loadFollowUps();
        updateStats();
        generateAISuggestions();
        console.log('✅ تم تحميل وعرض جميع البيانات بنجاح!');
    }, 300);
});

// Load Contacts
function loadContacts() {
    const contactsList = document.getElementById('contactsList');
    
    if (!contactsList) {
        console.error('❌ contactsList element not found');
        return;
    }
    
    // إعادة تحميل البيانات من localStorage للتأكد
    contacts = JSON.parse(localStorage.getItem('contacts') || '[]');
    
    console.log('تحميل جهات الاتصال:', contacts.length);
    
    if (!contacts || contacts.length === 0) {
        // إذا كانت فارغة، حمّل البيانات الافتراضية مرة أخرى
        contacts = [...sampleContacts];
        localStorage.setItem('contacts', JSON.stringify(contacts));
        console.log('⚠️ تم إعادة تحميل البيانات الافتراضية');
    }
    
    if (contacts.length === 0) {
        contactsList.innerHTML = `
            <li class="empty-state">
                <i class="fas fa-inbox" style="font-size: 3rem; color: var(--gray); margin-bottom: 1rem;"></i>
                <p style="color: var(--gray);">لا توجد جهات اتصال محفوظة بعد. ابدأ بمسح QR code!</p>
            </li>
        `;
        return;
    }
    
    contactsList.innerHTML = contacts.map(contact => `
        <li class="contact-item" onclick="openContactDetail('${contact.id}')">
            <div class="contact-info">
                <div class="contact-name">${contact.companyName || contact.name}</div>
                <div class="contact-details">
                    ${contact.expoId} • ${contact.category || 'غير محدد'} • ${formatDate(contact.scannedAt)}
                </div>
            </div>
            <div class="contact-actions">
                <button class="action-btn" onclick="event.stopPropagation(); scheduleFollowUp('${contact.id}')" title="جدولة متابعة">
                    <i class="fas fa-calendar-plus"></i>
                </button>
                <button class="action-btn" onclick="event.stopPropagation(); addNoteToContact('${contact.id}')" title="إضافة ملاحظة">
                    <i class="fas fa-sticky-note"></i>
                </button>
            </div>
        </li>
    `).join('');
}

// Load Notes
function loadNotes() {
    const notesList = document.getElementById('notesList');
    
    if (!notesList) {
        console.error('❌ notesList element not found');
        return;
    }
    
    // إعادة تحميل البيانات من localStorage للتأكد
    notes = JSON.parse(localStorage.getItem('notes') || '[]');
    
    console.log('تحميل الملاحظات:', notes.length);
    
    if (!notes || notes.length === 0) {
        // إذا كانت فارغة، حمّل البيانات الافتراضية مرة أخرى
        notes = [...sampleNotes];
        localStorage.setItem('notes', JSON.stringify(notes));
        console.log('⚠️ تم إعادة تحميل الملاحظات الافتراضية');
    }
    
    if (notes.length === 0) {
        notesList.innerHTML = `
            <div class="empty-state">
                <p style="color: var(--gray);">لا توجد ملاحظات بعد</p>
            </div>
        `;
        return;
    }
    
    notesList.innerHTML = notes.map(note => `
        <div class="note-item">
            <div class="note-text">${note.text}</div>
            <div class="note-meta">
                <span>${note.contactName || 'عام'}</span>
                <span>${formatDate(note.createdAt)}</span>
            </div>
        </div>
    `).join('');
}

// Load Follow-ups
function loadFollowUps() {
    // This would be displayed in a separate section or modal
    updateStats();
}

// Update Stats
function updateStats() {
    // إعادة تحميل البيانات من localStorage
    contacts = JSON.parse(localStorage.getItem('contacts') || '[]');
    notes = JSON.parse(localStorage.getItem('notes') || '[]');
    followUps = JSON.parse(localStorage.getItem('followUps') || '[]');
    
    const contactsCountEl = document.getElementById('contactsCount');
    const notesCountEl = document.getElementById('notesCount');
    const followUpsCountEl = document.getElementById('followUpsCount');
    
    if (contactsCountEl) contactsCountEl.textContent = contacts.length;
    if (notesCountEl) notesCountEl.textContent = notes.length;
    if (followUpsCountEl) followUpsCountEl.textContent = followUps.length;
}

// Open QR Scanner
function openQRScanner() {
    document.getElementById('qrScannerModal').classList.add('show');
}

// Close QR Scanner
function closeQRScanner() {
    document.getElementById('qrScannerModal').classList.remove('show');
}

// Simulate QR Scan (for demo)
function simulateQRScan() {
    // Simulate scanning a QR code - عرض معلومات البزنس والبروشورات
    const sampleContacts = [
        {
            id: '1',
            name: 'أحمد محمد',
            companyName: 'نقل بلس',
            expoId: 'Expo#2048',
            category: 'نقل',
            booth: 'B12',
            description: 'تطبيق نقل طلاب - حلول ذكية للنقل المدرسي. شركة رائدة في مجال النقل الذكي. تقدم خدمات نقل آمنة ومريحة للطلاب مع تتبع مباشر.',
            scannedAt: new Date().toISOString(),
            eventId: 'event1',
            eventName: 'معرض التعليم 2024',
            phone: '+966501111111',
            email: 'info@naqlplus.com',
            website: 'www.naqlplus.com',
            brochure: {
                title: 'حلول النقل الذكي للمدارس',
                description: 'نقدم حلول نقل متكاملة وآمنة للمدارس مع تتبع مباشر للطلاب وأولياء الأمور.',
                features: ['تتبع مباشر للطلاب', 'إشعارات فورية', 'تقارير يومية', 'دعم 24/7'],
                services: ['نقل مدرسي', 'رحلات تعليمية', 'نقل طوارئ'],
                brochureUrl: '#'
            }
        },
        {
            id: '2',
            name: 'سارة علي',
            companyName: 'تقنيات التعليم',
            expoId: 'Expo#3056',
            category: 'تعليم',
            booth: 'A5',
            description: 'حلول تعليمية ذكية ومنصات تعليم إلكتروني. منصات تفاعلية للتعلم عن بُعد مع محتوى تعليمي متقدم.',
            scannedAt: new Date().toISOString(),
            eventId: 'event1',
            eventName: 'معرض التعليم 2024',
            phone: '+966502222222',
            email: 'contact@edutech.com',
            website: 'www.edutech.com',
            brochure: {
                title: 'منصات التعليم الإلكتروني',
                description: 'حلول تعليمية متكاملة تجمع بين التقنية والتعليم لتحقيق أفضل النتائج.',
                features: ['فصول افتراضية', 'محتوى تفاعلي', 'تقييم تلقائي', 'تقارير شاملة'],
                services: ['منصات تعليمية', 'تدريب المعلمين', 'استشارات تعليمية'],
                brochureUrl: '#'
            }
        }
    ];
    
    const randomContact = sampleContacts[Math.floor(Math.random() * sampleContacts.length)];
    
    // Check if already exists
    const existingContact = contacts.find(c => c.expoId === randomContact.expoId);
    
    if (!existingContact) {
        contacts.push(randomContact);
        localStorage.setItem('contacts', JSON.stringify(contacts));
        loadContacts();
        updateStats();
        
        // عرض معلومات البزنس والبروشورات مباشرة بعد المسح
        setTimeout(() => {
            openContactDetail(randomContact.id);
            showToast('تم حفظ جهة الاتصال بنجاح!', 'success');
        }, 300);
    } else {
        // إذا كانت موجودة، اعرض التفاصيل
        openContactDetail(existingContact.id);
        showToast('هذه الجهة محفوظة بالفعل', 'info');
    }
    
    closeQRScanner();
}

// Add Contact by ID
function addContactByID() {
    const expoId = document.getElementById('manualExpoId').value.trim();
    
    if (!expoId) {
        showToast('يرجى إدخال ExpoID', 'error');
        return;
    }
    
    // Check if already exists
    if (contacts.find(c => c.expoId === expoId)) {
        showToast('هذه الجهة محفوظة بالفعل', 'error');
        return;
    }
    
    // Create sample contact
    const newContact = {
        id: Date.now().toString(),
        name: 'مستخدم',
        companyName: 'شركة',
        expoId: expoId,
        category: 'غير محدد',
        scannedAt: new Date().toISOString(),
        eventId: 'event1',
        eventName: 'معرض التعليم 2024'
    };
    
    contacts.push(newContact);
    localStorage.setItem('contacts', JSON.stringify(contacts));
    loadContacts();
    updateStats();
    document.getElementById('manualExpoId').value = '';
    showToast('تم حفظ جهة الاتصال بنجاح!', 'success');
}

// Open Contact Detail
function openContactDetail(contactId) {
    const contact = contacts.find(c => c.id === contactId);
    if (!contact) return;
    
    const modal = document.getElementById('contactModal');
    const content = document.getElementById('contactModalContent');
    
    // Get contact notes
    const contactNotes = notes.filter(n => n.contactId === contactId);
    const contactFollowUps = followUps.filter(f => f.contactId === contactId);
    
    content.innerHTML = `
        <div class="contact-detail">
            <div class="contact-detail-header">
                <div class="contact-avatar">
                    <i class="fas fa-building"></i>
                </div>
                <h3>${contact.companyName || contact.name}</h3>
                <div class="contact-expo-id">${contact.expoId}</div>
            </div>
            
            <div class="contact-detail-section">
                <h4><i class="fas fa-info-circle"></i> معلومات الاتصال</h4>
                <div class="contact-info-item">
                    <span class="contact-info-label">الاسم:</span>
                    <span class="contact-info-value">${contact.name}</span>
                </div>
                <div class="contact-info-item">
                    <span class="contact-info-label">الفئة:</span>
                    <span class="contact-info-value">${contact.category || 'غير محدد'}</span>
                </div>
                ${contact.booth ? `
                <div class="contact-info-item">
                    <span class="contact-info-label">الجناح:</span>
                    <span class="contact-info-value">${contact.booth}</span>
                </div>
                ` : ''}
                <div class="contact-info-item">
                    <span class="contact-info-label">تاريخ المسح:</span>
                    <span class="contact-info-value">${formatDate(contact.scannedAt)}</span>
                </div>
            </div>
            
            ${contact.description ? `
            <div class="contact-detail-section">
                <h4><i class="fas fa-align-right"></i> الوصف</h4>
                <p style="color: var(--gray); line-height: 1.8;">${contact.description}</p>
            </div>
            ` : ''}
            
            ${contact.phone || contact.email || contact.website ? `
            <div class="contact-detail-section">
                <h4><i class="fas fa-address-book"></i> معلومات التواصل</h4>
                ${contact.phone ? `
                <div class="contact-info-item">
                    <span class="contact-info-label"><i class="fas fa-phone"></i> الهاتف:</span>
                    <a href="tel:${contact.phone}" style="color: var(--primary); text-decoration: none;">${contact.phone}</a>
                </div>
                ` : ''}
                ${contact.email ? `
                <div class="contact-info-item">
                    <span class="contact-info-label"><i class="fas fa-envelope"></i> البريد:</span>
                    <a href="mailto:${contact.email}" style="color: var(--primary); text-decoration: none;">${contact.email}</a>
                </div>
                ` : ''}
                ${contact.website ? `
                <div class="contact-info-item">
                    <span class="contact-info-label"><i class="fas fa-globe"></i> الموقع:</span>
                    <a href="https://${contact.website}" target="_blank" style="color: var(--primary); text-decoration: none;">${contact.website}</a>
                </div>
                ` : ''}
            </div>
            ` : ''}
            
            ${contact.brochure ? `
            <div class="contact-detail-section" style="background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%); padding: 1.5rem; border-radius: 12px; color: white; margin: 1.5rem 0;">
                <h4 style="color: white; margin-bottom: 1rem;"><i class="fas fa-file-pdf"></i> البروشور الرقمي</h4>
                <h3 style="color: white; margin-bottom: 0.5rem;">${contact.brochure.title}</h3>
                <p style="color: rgba(255, 255, 255, 0.9); line-height: 1.8; margin-bottom: 1rem;">${contact.brochure.description}</p>
                
                ${contact.brochure.features ? `
                <div style="margin: 1rem 0;">
                    <h5 style="color: white; margin-bottom: 0.5rem;"><i class="fas fa-star"></i> المميزات:</h5>
                    <ul style="list-style: none; padding: 0; margin: 0;">
                        ${contact.brochure.features.map(feature => `
                            <li style="padding: 0.5rem 0; border-bottom: 1px solid rgba(255, 255, 255, 0.2);">
                                <i class="fas fa-check-circle" style="margin-left: 0.5rem; color: #FFD700;"></i>
                                ${feature}
                            </li>
                        `).join('')}
                    </ul>
                </div>
                ` : ''}
                
                ${contact.brochure.services ? `
                <div style="margin: 1rem 0;">
                    <h5 style="color: white; margin-bottom: 0.5rem;"><i class="fas fa-briefcase"></i> الخدمات:</h5>
                    <div style="display: flex; flex-wrap: wrap; gap: 0.5rem;">
                        ${contact.brochure.services.map(service => `
                            <span style="background: rgba(255, 255, 255, 0.2); padding: 0.5rem 1rem; border-radius: 20px; font-size: 0.9rem;">
                                ${service}
                            </span>
                        `).join('')}
                    </div>
                </div>
                ` : ''}
                
                <div style="margin-top: 1.5rem; display: flex; gap: 0.5rem; flex-wrap: wrap;">
                    ${contact.brochure.fileUrl ? `
                    <a href="${contact.brochure.fileUrl}" target="_blank" class="btn" style="background: white; color: var(--primary); flex: 1; border: none; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                        <i class="fas fa-file-pdf"></i> ${contact.brochure.fileName ? `تحميل ${contact.brochure.fileName}` : 'تحميل البروشور'}
                    </a>
                    ` : ''}
                    <button class="btn" onclick="viewBrochure('${contact.id}')" style="background: rgba(255, 255, 255, 0.2); color: white; flex: 1; border: 2px solid white;">
                        <i class="fas fa-eye"></i> عرض كامل
                    </button>
                </div>
            </div>
            ` : ''}
            
            <div class="contact-detail-section">
                <h4><i class="fas fa-sticky-note"></i> إضافة ملاحظة</h4>
                <div class="add-note-form">
                    <textarea id="noteText" placeholder="اكتب ملاحظتك هنا..."></textarea>
                    <div class="note-actions">
                        <button class="btn btn-primary" onclick="saveNote('${contactId}')">
                            <i class="fas fa-save"></i> حفظ
                        </button>
                        <button class="btn btn-outline voice-note-btn" onclick="startVoiceNote()" id="voiceNoteBtn">
                            <i class="fas fa-microphone"></i> صوتي
                        </button>
                    </div>
                </div>
            </div>
            
            ${contactNotes.length > 0 ? `
            <div class="contact-detail-section">
                <h4><i class="fas fa-list"></i> الملاحظات (${contactNotes.length})</h4>
                ${contactNotes.map(note => `
                    <div class="note-item">
                        <div class="note-text">${note.text}</div>
                        <div class="note-meta">
                            <span>${formatDate(note.createdAt)}</span>
                        </div>
                    </div>
                `).join('')}
            </div>
            ` : ''}
            
            <div class="contact-detail-section">
                <h4><i class="fas fa-calendar-check"></i> جدولة متابعة</h4>
                <div class="follow-up-form">
                    <div class="follow-up-options">
                        <div class="follow-up-option" onclick="selectFollowUp('3days')">3 أيام</div>
                        <div class="follow-up-option" onclick="selectFollowUp('1week')">أسبوع</div>
                        <div class="follow-up-option" onclick="selectFollowUp('2weeks')">أسبوعان</div>
                        <div class="follow-up-option" onclick="selectFollowUp('1month')">شهر</div>
                    </div>
                    <button class="btn btn-primary" onclick="saveFollowUp('${contactId}')" style="width: 100%;">
                        <i class="fas fa-calendar-plus"></i> حفظ المتابعة
                    </button>
                </div>
            </div>
            
            <div class="form-actions" style="margin-top: 2rem;">
                <button class="btn btn-success" onclick="sendWhatsApp('${contact.expoId}')" style="flex: 1;">
                    <i class="fab fa-whatsapp"></i> واتساب
                </button>
                <button class="btn btn-outline" onclick="closeContactModal()" style="flex: 1;">
                    إغلاق
                </button>
            </div>
        </div>
    `;
    
    modal.classList.add('show');
    selectedFollowUpPeriod = null;
}

// Close Contact Modal
function closeContactModal() {
    document.getElementById('contactModal').classList.remove('show');
}

// Save Note
function saveNote(contactId) {
    const noteText = document.getElementById('noteText').value.trim();
    
    if (!noteText) {
        showToast('يرجى إدخال نص الملاحظة', 'error');
        return;
    }
    
    const contact = contacts.find(c => c.id === contactId);
    
    const note = {
        id: Date.now().toString(),
        contactId: contactId,
        contactName: contact?.companyName || contact?.name,
        text: noteText,
        createdAt: new Date().toISOString()
    };
    
    notes.push(note);
    localStorage.setItem('notes', JSON.stringify(notes));
    
    loadNotes();
    updateStats();
    showToast('تم حفظ الملاحظة بنجاح!', 'success');
    
    // Refresh contact detail
    openContactDetail(contactId);
}

// Voice Note (Simulated)
let isRecording = false;
function startVoiceNote() {
    const btn = document.getElementById('voiceNoteBtn');
    
    if (!isRecording) {
        isRecording = true;
        btn.classList.add('recording');
        btn.innerHTML = '<i class="fas fa-stop"></i> إيقاف';
        showToast('جاري التسجيل...', 'success');
        
        // Simulate transcription after 3 seconds
        setTimeout(() => {
            stopVoiceNote();
            const transcribedText = 'ملاحظة صوتية محولة: مناقشة استخدام تطبيق سمستر. متابعة بعد أسبوعين.';
            document.getElementById('noteText').value = transcribedText;
            showToast('تم تحويل الصوت إلى نص!', 'success');
        }, 3000);
    } else {
        stopVoiceNote();
    }
}

function stopVoiceNote() {
    isRecording = false;
    const btn = document.getElementById('voiceNoteBtn');
    btn.classList.remove('recording');
    btn.innerHTML = '<i class="fas fa-microphone"></i> صوتي';
}

// Follow-up Scheduler
let selectedFollowUpPeriod = null;

function selectFollowUp(period) {
    selectedFollowUpPeriod = period;
    document.querySelectorAll('.follow-up-option').forEach(opt => {
        opt.classList.remove('selected');
    });
    event.target.classList.add('selected');
}

function scheduleFollowUp(contactId) {
    openContactDetail(contactId);
}

function saveFollowUp(contactId) {
    if (!selectedFollowUpPeriod) {
        showToast('يرجى اختيار فترة المتابعة', 'error');
        return;
    }
    
    const contact = contacts.find(c => c.id === contactId);
    const periods = {
        '3days': 3,
        '1week': 7,
        '2weeks': 14,
        '1month': 30
    };
    
    const days = periods[selectedFollowUpPeriod];
    const followUpDate = new Date();
    followUpDate.setDate(followUpDate.getDate() + days);
    
    const followUp = {
        id: Date.now().toString(),
        contactId: contactId,
        contactName: contact?.companyName || contact?.name,
        date: followUpDate.toISOString(),
        period: selectedFollowUpPeriod,
        createdAt: new Date().toISOString()
    };
    
    followUps.push(followUp);
    localStorage.setItem('followUps', JSON.stringify(followUps));
    
    updateStats();
    showToast(`تم جدولة المتابعة بعد ${days} يوم!`, 'success');
    closeContactModal();
}

// Generate AI Suggestions
// دور الذكاء الاصطناعي للزائر:
// 1. تحليل جهات الاتصال وتحديد الأولويات
// 2. اقتراح نصوص متابعة جاهزة
// 3. تحليل معدل التفاعل وتقديم توصيات
// 4. اقتراح أفضل الأوقات للمتابعة
function generateAISuggestions() {
    const suggestionText = document.getElementById('aiSuggestionText');
    
    if (contacts.length === 0) {
        suggestionText.innerHTML = `
            <p style="margin-bottom: 0.5rem; color: var(--gray);">
                <i class="fas fa-info-circle"></i> ابدأ بمسح QR codes للحصول على اقتراحات مخصصة من ExpoAI
            </p>
        `;
        return;
    }
    
    // تحليل البيانات وتوليد اقتراحات ذكية
    const topContacts = contacts.slice(0, 3);
    const recentContacts = contacts.filter(c => {
        const daysDiff = (Date.now() - new Date(c.scannedAt).getTime()) / (1000 * 60 * 60 * 24);
        return daysDiff <= 7;
    });
    
    const followUpCount = followUps.length;
    const notesCount = notes.length;
    
    // بيانات افتراضية للذكاء الاصطناعي - يمكن استبدالها بـ AI حقيقي
    const aiSuggestions = [
        {
            type: 'priority',
            icon: 'fas fa-star',
            title: 'أفضل الشركات للمتابعة',
            content: `ركز على متابعة: ${topContacts.map(c => c.companyName || c.name).join('، ')}`
        },
        {
            type: 'message',
            icon: 'fas fa-comment',
            title: 'نص متابعة جاهز',
            content: `"السلام عليكم، سعدت بلقائكم في معرض التعليم 2024. هل نستطيع تحديد موعد مكالمة لمناقشة فرص التعاون؟"`
        },
        {
            type: 'stats',
            icon: 'fas fa-chart-line',
            title: 'تحليل نشاطك',
            content: `لديك ${contacts.length} لقاء محفوظ، ${notesCount} ملاحظة، و ${followUpCount} متابعة مجدولة. استمر في المسح!`
        },
        {
            type: 'timing',
            icon: 'fas fa-clock',
            title: 'أفضل وقت للمتابعة',
            content: `بناءً على تحليل التفاعلات، أفضل وقت للمتابعة هو الصباح (9-11 ص) أو بعد الظهر (2-4 م)`
        }
    ];
    
    // عرض الاقتراحات بشكل منظم
    suggestionText.innerHTML = aiSuggestions.map(suggestion => `
        <div style="background: rgba(255, 255, 255, 0.1); padding: 1rem; border-radius: 8px; margin-bottom: 0.75rem; border-right: 3px solid var(--white);">
            <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                <i class="${suggestion.icon}"></i>
                <strong>${suggestion.title}:</strong>
            </div>
            <div style="padding-right: 1.5rem; line-height: 1.6;">
                ${suggestion.content}
            </div>
        </div>
    `).join('');
}

// Filter Contacts
function filterContacts() {
    const searchTerm = document.getElementById('searchContacts').value.toLowerCase();
    const filterValue = document.getElementById('filterContacts').value;
    
    let filtered = contacts;
    
    if (searchTerm) {
        filtered = filtered.filter(c => 
            (c.companyName || c.name).toLowerCase().includes(searchTerm) ||
            c.expoId.toLowerCase().includes(searchTerm) ||
            (c.category || '').toLowerCase().includes(searchTerm)
        );
    }
    
    if (filterValue) {
        filtered = filtered.filter(c => c.eventId === filterValue);
    }
    
    const contactsList = document.getElementById('contactsList');
    
    if (filtered.length === 0) {
        contactsList.innerHTML = `
            <li class="empty-state">
                <p style="color: var(--gray);">لا توجد نتائج</p>
            </li>
        `;
        return;
    }
    
    contactsList.innerHTML = filtered.map(contact => `
        <li class="contact-item" onclick="openContactDetail('${contact.id}')">
            <div class="contact-info">
                <div class="contact-name">${contact.companyName || contact.name}</div>
                <div class="contact-details">
                    ${contact.expoId} • ${contact.category || 'غير محدد'} • ${formatDate(contact.scannedAt)}
                </div>
            </div>
            <div class="contact-actions">
                <button class="action-btn" onclick="event.stopPropagation(); scheduleFollowUp('${contact.id}')" title="جدولة متابعة">
                    <i class="fas fa-calendar-plus"></i>
                </button>
                <button class="action-btn" onclick="event.stopPropagation(); addNoteToContact('${contact.id}')" title="إضافة ملاحظة">
                    <i class="fas fa-sticky-note"></i>
                </button>
            </div>
        </li>
    `).join('');
}

// Add Note to Contact
function addNoteToContact(contactId) {
    openContactDetail(contactId);
    setTimeout(() => {
        document.getElementById('noteText').focus();
    }, 300);
}

// Send WhatsApp
function sendWhatsApp(expoId) {
    const message = encodeURIComponent('السلام عليكم، سعدت بلقائكم في المعرض. هل نستطيع تحديد موعد مكالمة؟');
    window.open(`https://wa.me/?text=${message}`, '_blank');
}

// Format Date
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('ar-SA', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

// Reset Demo Data - إعادة تعيين البيانات الافتراضية
function resetDemoData() {
    if (confirm('هل تريد إعادة تعيين البيانات الافتراضية؟ سيتم حذف جميع البيانات الحالية.')) {
        // مسح البيانات الحالية
        localStorage.removeItem('contacts');
        localStorage.removeItem('notes');
        localStorage.removeItem('followUps');
        localStorage.removeItem('hasDefaultData');
        
        // إعادة تحميل البيانات الافتراضية
        contacts = [...sampleContacts];
        notes = [...sampleNotes];
        followUps = [...sampleFollowUps];
        
        localStorage.setItem('contacts', JSON.stringify(contacts));
        localStorage.setItem('notes', JSON.stringify(notes));
        localStorage.setItem('followUps', JSON.stringify(followUps));
        
        // إعادة تحميل الصفحة
        loadContacts();
        loadNotes();
        loadFollowUps();
        updateStats();
        generateAISuggestions();
        
        showToast('تم إعادة تعيين البيانات الافتراضية بنجاح!', 'success');
    }
}

// Show Toast
function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

