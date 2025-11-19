// Exhibitor Dashboard JavaScript

// تحميل البيانات من localStorage (إذا كانت موجودة)
let leads = JSON.parse(localStorage.getItem('exhibitorLeads') || '[]');
// currentUser - تحميل من localStorage مباشرة
let currentUser = JSON.parse(localStorage.getItem('currentUser') || '{}');

// Sample leads data for demo - بيانات تفصيلية وواقعية
// هذه Leads من زوار مسحوا QR code الجناح في المعرض
// كل Lead يمثل لقاء حقيقي بين العارض والزائر
const sampleLeads = [
    {
        id: '1',
        visitorName: 'محمد أحمد',
        visitorExpoId: 'Expo#1200',
        scannedAt: new Date(Date.now() - 2 * 3600000).toISOString(),
        aiScore: 85,
        status: 'interested',
        category: 'تعليم',
        booth: 'B12',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم جداً بتطبيق نقل الطلاب. طلب عرض توضيحي خلال أسبوع. لديه 50 مدرسة كعميل محتمل.'],
        followUpDate: new Date(Date.now() + 7 * 86400000).toISOString(),
        phone: '+966501234567',
        email: 'mohammed@example.com'
    },
    {
        id: '2',
        visitorName: 'فاطمة علي',
        visitorExpoId: 'Expo#1305',
        scannedAt: new Date(Date.now() - 5 * 3600000).toISOString(),
        aiScore: 72,
        status: 'follow-up',
        category: 'نقل',
        booth: 'A5',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم بشراكة تنفيذية. مناقشة استخدام تطبيق سمستر. متابعة بعد أسبوعين.'],
        followUpDate: new Date(Date.now() + 14 * 86400000).toISOString(),
        phone: '+966502345678',
        email: 'fatima@example.com'
    },
    {
        id: '3',
        visitorName: 'خالد سعيد',
        visitorExpoId: 'Expo#1456',
        scannedAt: new Date(Date.now() - 86400000).toISOString(),
        aiScore: 45,
        status: 'not-interested',
        category: 'استثمار',
        booth: 'C8',
        eventName: 'معرض التعليم 2024',
        notes: ['استفسار عام فقط. غير مهتم حالياً.'],
        followUpDate: null,
        phone: '+966503456789',
        email: 'khaled@example.com'
    },
    {
        id: '4',
        visitorName: 'نورا محمد',
        visitorExpoId: 'Expo#2100',
        scannedAt: new Date(Date.now() - 3 * 3600000).toISOString(),
        aiScore: 90,
        status: 'interested',
        category: 'تعليم',
        booth: 'D3',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم جداً! طلب عرض فوري. إمكانية شراكة استراتيجية. لديه ميزانية كبيرة.'],
        followUpDate: new Date(Date.now() + 3 * 86400000).toISOString(),
        phone: '+966504567890',
        email: 'nora@example.com'
    },
    {
        id: '5',
        visitorName: 'أحمد سالم',
        visitorExpoId: 'Expo#1890',
        scannedAt: new Date(Date.now() - 86400000).toISOString(),
        aiScore: 68,
        status: 'follow-up',
        category: 'نقل',
        booth: 'E7',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة أولية. يحتاج وقت للتفكير. متابعة بعد أسبوع.'],
        followUpDate: new Date(Date.now() + 7 * 86400000).toISOString(),
        phone: '+966505678901',
        email: 'ahmed@example.com'
    },
    {
        id: '6',
        visitorName: 'سارة الخالدي',
        visitorExpoId: 'Expo#2200',
        scannedAt: new Date(Date.now() - 1 * 3600000).toISOString(),
        aiScore: 88,
        status: 'interested',
        category: 'تعليم',
        booth: 'F10',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم جداً بالحل. طلب عرض توضيحي فوري. إمكانية تطبيق تجريبي.'],
        followUpDate: new Date(Date.now() + 2 * 86400000).toISOString(),
        phone: '+966506789012',
        email: 'sara@example.com'
    },
    {
        id: '7',
        visitorName: 'عبدالله القحطاني',
        visitorExpoId: 'Expo#2300',
        scannedAt: new Date(Date.now() - 4 * 3600000).toISOString(),
        aiScore: 75,
        status: 'follow-up',
        category: 'تعليم',
        booth: 'G15',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة جيدة. يحتاج عرض مفصل. متابعة خلال أسبوع.'],
        followUpDate: new Date(Date.now() + 7 * 86400000).toISOString(),
        phone: '+966507890123',
        email: 'abdullah@example.com'
    },
    {
        id: '8',
        visitorName: 'ليلى المطيري',
        visitorExpoId: 'Expo#2400',
        scannedAt: new Date(Date.now() - 6 * 3600000).toISOString(),
        aiScore: 82,
        status: 'interested',
        category: 'تعليم',
        booth: 'H8',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم بالحل. طلب عرض مع الأسعار. إمكانية شراكة طويلة الأمد.'],
        followUpDate: new Date(Date.now() + 5 * 86400000).toISOString(),
        phone: '+966508901234',
        email: 'layla@example.com'
    },
    {
        id: '9',
        visitorName: 'يوسف الحربي',
        visitorExpoId: 'Expo#2500',
        scannedAt: new Date(Date.now() - 2 * 86400000).toISOString(),
        aiScore: 55,
        status: 'not-interested',
        category: 'استثمار',
        booth: 'I12',
        eventName: 'معرض التعليم 2024',
        notes: ['استفسار عام. غير مناسب لاحتياجاتهم حالياً.'],
        followUpDate: null,
        phone: '+966509012345',
        email: 'youssef@example.com'
    },
    {
        id: '10',
        visitorName: 'ريم العتيبي',
        visitorExpoId: 'Expo#2600',
        scannedAt: new Date(Date.now() - 7 * 3600000).toISOString(),
        aiScore: 79,
        status: 'follow-up',
        category: 'تعليم',
        booth: 'J5',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة إيجابية. طلب معلومات إضافية. متابعة خلال 10 أيام.'],
        followUpDate: new Date(Date.now() + 10 * 86400000).toISOString(),
        phone: '+966500123456',
        email: 'reem@example.com'
    },
    {
        id: '11',
        visitorName: 'طارق الدوسري',
        visitorExpoId: 'Expo#2700',
        scannedAt: new Date(Date.now() - 8 * 3600000).toISOString(),
        aiScore: 91,
        status: 'interested',
        category: 'تعليم',
        booth: 'K20',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم جداً! طلب عرض فوري. إمكانية شراكة استراتيجية كبيرة.'],
        followUpDate: new Date(Date.now() + 1 * 86400000).toISOString(),
        phone: '+966501234567',
        email: 'tariq@example.com'
    },
    {
        id: '12',
        visitorName: 'هند الشمري',
        visitorExpoId: 'Expo#2800',
        scannedAt: new Date(Date.now() - 3 * 86400000).toISOString(),
        aiScore: 63,
        status: 'follow-up',
        category: 'نقل',
        booth: 'L8',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة أولية. يحتاج وقت للدراسة. متابعة بعد أسبوعين.'],
        followUpDate: new Date(Date.now() + 14 * 86400000).toISOString(),
        phone: '+966502345678',
        email: 'hind@example.com'
    },
    {
        id: '13',
        visitorName: 'بدر العريفي',
        visitorExpoId: 'Expo#2900',
        scannedAt: new Date(Date.now() - 9 * 3600000).toISOString(),
        aiScore: 86,
        status: 'interested',
        category: 'تعليم',
        booth: 'M15',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم بالحل. طلب عرض تفصيلي مع خطة التنفيذ.'],
        followUpDate: new Date(Date.now() + 4 * 86400000).toISOString(),
        phone: '+966503456789',
        email: 'badr@example.com'
    },
    {
        id: '14',
        visitorName: 'سعد الفهد',
        visitorExpoId: 'Expo#3000',
        scannedAt: new Date(Date.now() - 4 * 86400000).toISOString(),
        aiScore: 48,
        status: 'not-interested',
        category: 'استثمار',
        booth: 'N12',
        eventName: 'معرض التعليم 2024',
        notes: ['استفسار سريع. غير مناسب.'],
        followUpDate: null,
        phone: '+966504567890',
        email: 'saad@example.com'
    },
    {
        id: '15',
        visitorName: 'لينا الزهراني',
        visitorExpoId: 'Expo#3100',
        scannedAt: new Date(Date.now() - 10 * 3600000).toISOString(),
        aiScore: 77,
        status: 'follow-up',
        category: 'تعليم',
        booth: 'O5',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة جيدة. طلب عرض مع الأسعار. متابعة خلال أسبوع.'],
        followUpDate: new Date(Date.now() + 7 * 86400000).toISOString(),
        phone: '+966505678901',
        email: 'lina@example.com'
    },
    {
        id: '16',
        visitorName: 'مشعل الغامدي',
        visitorExpoId: 'Expo#3200',
        scannedAt: new Date(Date.now() - 5 * 86400000).toISOString(),
        aiScore: 70,
        status: 'follow-up',
        category: 'تعليم',
        booth: 'P20',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة أولية. يحتاج معلومات إضافية. متابعة بعد 10 أيام.'],
        followUpDate: new Date(Date.now() + 10 * 86400000).toISOString(),
        phone: '+966506789012',
        email: 'mishal@example.com'
    },
    {
        id: '17',
        visitorName: 'داليا الخالدي',
        visitorExpoId: 'Expo#3300',
        scannedAt: new Date(Date.now() - 11 * 3600000).toISOString(),
        aiScore: 84,
        status: 'interested',
        category: 'تعليم',
        booth: 'Q8',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم جداً. طلب عرض فوري. إمكانية تطبيق تجريبي.'],
        followUpDate: new Date(Date.now() + 3 * 86400000).toISOString(),
        phone: '+966507890123',
        email: 'dalia@example.com'
    },
    {
        id: '18',
        visitorName: 'عمر المالكي',
        visitorExpoId: 'Expo#3400',
        scannedAt: new Date(Date.now() - 6 * 86400000).toISOString(),
        aiScore: 59,
        status: 'not-interested',
        category: 'استثمار',
        booth: 'R15',
        eventName: 'معرض التعليم 2024',
        notes: ['استفسار عام. غير مناسب.'],
        followUpDate: null,
        phone: '+966508901234',
        email: 'omar@example.com'
    },
    {
        id: '19',
        visitorName: 'سلمى القحطاني',
        visitorExpoId: 'Expo#3500',
        scannedAt: new Date(Date.now() - 12 * 3600000).toISOString(),
        aiScore: 80,
        status: 'interested',
        category: 'تعليم',
        booth: 'S12',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة ممتازة. طلب عرض تفصيلي. إمكانية شراكة.'],
        followUpDate: new Date(Date.now() + 5 * 86400000).toISOString(),
        phone: '+966509012345',
        email: 'salma@example.com'
    },
    {
        id: '20',
        visitorName: 'خالد العتيبي',
        visitorExpoId: 'Expo#3600',
        scannedAt: new Date(Date.now() - 7 * 86400000).toISOString(),
        aiScore: 66,
        status: 'follow-up',
        category: 'نقل',
        booth: 'T5',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة أولية. يحتاج وقت للتفكير. متابعة بعد أسبوعين.'],
        followUpDate: new Date(Date.now() + 14 * 86400000).toISOString(),
        phone: '+966500123456',
        email: 'khalid@example.com'
    },
    {
        id: '21',
        visitorName: 'نورة الشمري',
        visitorExpoId: 'Expo#3700',
        scannedAt: new Date(Date.now() - 13 * 3600000).toISOString(),
        aiScore: 87,
        status: 'interested',
        category: 'تعليم',
        booth: 'U20',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم جداً! طلب عرض فوري مع خطة التنفيذ. إمكانية شراكة كبيرة.'],
        followUpDate: new Date(Date.now() + 2 * 86400000).toISOString(),
        phone: '+966501234567',
        email: 'nora2@example.com'
    },
    {
        id: '22',
        visitorName: 'فهد الدوسري',
        visitorExpoId: 'Expo#3800',
        scannedAt: new Date(Date.now() - 8 * 86400000).toISOString(),
        aiScore: 73,
        status: 'follow-up',
        category: 'تعليم',
        booth: 'V8',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة جيدة. طلب معلومات إضافية. متابعة خلال أسبوع.'],
        followUpDate: new Date(Date.now() + 7 * 86400000).toISOString(),
        phone: '+966502345678',
        email: 'fahad@example.com'
    },
    {
        id: '23',
        visitorName: 'ريم العريفي',
        visitorExpoId: 'Expo#3900',
        scannedAt: new Date(Date.now() - 14 * 3600000).toISOString(),
        aiScore: 89,
        status: 'interested',
        category: 'تعليم',
        booth: 'W15',
        eventName: 'معرض التعليم 2024',
        notes: ['مهتم جداً بالحل. طلب عرض فوري. إمكانية تطبيق تجريبي فوري.'],
        followUpDate: new Date(Date.now() + 1 * 86400000).toISOString(),
        phone: '+966503456789',
        email: 'reem2@example.com'
    },
    {
        id: '24',
        visitorName: 'عبدالرحمن الفهد',
        visitorExpoId: 'Expo#4000',
        scannedAt: new Date(Date.now() - 9 * 86400000).toISOString(),
        aiScore: 52,
        status: 'not-interested',
        category: 'استثمار',
        booth: 'X12',
        eventName: 'معرض التعليم 2024',
        notes: ['استفسار سريع. غير مناسب لاحتياجاتهم.'],
        followUpDate: null,
        phone: '+966504567890',
        email: 'abdulrahman@example.com'
    },
    {
        id: '25',
        visitorName: 'مريم الزهراني',
        visitorExpoId: 'Expo#4100',
        scannedAt: new Date(Date.now() - 15 * 3600000).toISOString(),
        aiScore: 81,
        status: 'interested',
        category: 'تعليم',
        booth: 'Y5',
        eventName: 'معرض التعليم 2024',
        notes: ['مناقشة ممتازة. طلب عرض تفصيلي مع الأسعار. إمكانية شراكة.'],
        followUpDate: new Date(Date.now() + 4 * 86400000).toISOString(),
        phone: '+966505678901',
        email: 'mariam@example.com'
    }
];

// Initialize Dashboard
document.addEventListener('DOMContentLoaded', function() {
    console.log('بدء تحميل لوحة تحكم العارض...');
    
    // إنشاء مستخدم افتراضي للعارض إذا لم يكن موجوداً (للتجربة بدون تسجيل)
    if (!currentUser || !currentUser.id || currentUser.role !== 'exhibitor') {
        currentUser = {
            id: 'exhibitor-demo',
            expoId: 'Expo#2048',
            name: 'أحمد محمد',
            companyName: 'نقل بلس',
            role: 'exhibitor',
            category: 'نقل',
            email: 'info@naqlplus.com',
            phone: '+966501111111',
            createdAt: new Date().toISOString()
        };
        localStorage.setItem('currentUser', JSON.stringify(currentUser));
        console.log('تم إنشاء مستخدم افتراضي:', currentUser.expoId);
    }
    
    // Set ExpoID
    const expoIdElement = document.getElementById('companyExpoId');
    if (expoIdElement && currentUser.expoId) {
        expoIdElement.textContent = currentUser.expoId;
    }
    
    // Load sample leads automatically for demo - إجبارياً
    // البيانات الافتراضية تظهر تلقائياً لمحاكاة تجربة المعرض الحقيقية
    // هذه Leads من زوار مسحوا QR code الجناح - محاكاة واقعية (25 Lead)
    
    // تحميل البيانات الافتراضية إجبارياً للتجربة
    leads = [...sampleLeads];
    localStorage.setItem('exhibitorLeads', JSON.stringify(leads));
    
    console.log('✅ تم تحميل البيانات الافتراضية:');
    console.log('  - Leads:', leads.length);
    
    // Load company info
    loadCompanyInfo();
    
    // Load data with small delay to ensure DOM is ready
    setTimeout(() => {
        console.log('بدء عرض البيانات...');
        loadLeads();
        updateStats();
        generateExhibitorAISuggestions();
        console.log('✅ تم تحميل وعرض جميع البيانات بنجاح!');
    }, 300);
});

// Load Leads
function loadLeads() {
    const tbody = document.getElementById('leadsTableBody');
    
    if (!tbody) {
        console.error('❌ leadsTableBody element not found');
        return;
    }
    
    // إعادة تحميل البيانات من localStorage للتأكد
    leads = JSON.parse(localStorage.getItem('exhibitorLeads') || '[]');
    
    console.log('تحميل Leads:', leads.length);
    
    if (!leads || leads.length === 0) {
        // إذا كانت فارغة، حمّل البيانات الافتراضية مرة أخرى
        leads = [...sampleLeads];
        localStorage.setItem('exhibitorLeads', JSON.stringify(leads));
        console.log('⚠️ تم إعادة تحميل Leads الافتراضية');
    }
    
    if (leads.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" style="text-align: center; padding: 3rem; color: var(--gray);">
                    <i class="fas fa-inbox" style="font-size: 3rem; margin-bottom: 1rem; display: block;"></i>
                    لا توجد Leads بعد
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = leads.map(lead => {
        const scoreClass = lead.aiScore >= 70 ? 'high' : lead.aiScore >= 50 ? 'medium' : 'low';
        const statusText = {
            'interested': 'مهتم',
            'follow-up': 'متابعة',
            'not-interested': 'غير مهتم',
            'contacted': 'تم التواصل'
        };
        
        return `
            <tr onclick="openLeadDetail('${lead.id}')" style="cursor: pointer;">
                <td>${lead.visitorName}</td>
                <td><code>${lead.visitorExpoId}</code></td>
                <td>${formatDate(lead.scannedAt)}</td>
                <td>
                    <span class="ai-score ${scoreClass}">
                        <i class="fas fa-star"></i>
                        ${lead.aiScore}
                    </span>
                </td>
                <td>${statusText[lead.status] || lead.status}</td>
                <td>
                    <button class="action-btn" onclick="event.stopPropagation(); openLeadDetail('${lead.id}')" title="عرض التفاصيل">
                        <i class="fas fa-eye"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

// Update Stats
function updateStats() {
    // إعادة تحميل البيانات من localStorage
    leads = JSON.parse(localStorage.getItem('exhibitorLeads') || '[]');
    
    const today = new Date().toDateString();
    const todayScans = leads.filter(l => new Date(l.scannedAt).toDateString() === today).length;
    const followUps = leads.filter(l => l.followUpDate).length;
    const conversionRate = leads.length > 0 ? Math.round((followUps / leads.length) * 100) : 0;
    const avgScore = leads.length > 0 
        ? Math.round(leads.reduce((sum, l) => sum + l.aiScore, 0) / leads.length) 
        : 0;
    
    const leadsCountEl = document.getElementById('leadsCount');
    const scansCountEl = document.getElementById('scansCount');
    const conversionRateEl = document.getElementById('conversionRate');
    const avgInterestEl = document.getElementById('avgInterest');
    
    if (leadsCountEl) leadsCountEl.textContent = leads.length;
    if (scansCountEl) scansCountEl.textContent = todayScans;
    if (conversionRateEl) conversionRateEl.textContent = conversionRate + '%';
    if (avgInterestEl) avgInterestEl.textContent = avgScore;
}

// Open Lead Detail
function openLeadDetail(leadId) {
    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;
    
    const modal = document.getElementById('leadModal');
    const content = document.getElementById('leadModalContent');
    
    const statusOptions = {
        'interested': 'مهتم',
        'follow-up': 'متابعة',
        'not-interested': 'غير مهتم',
        'contacted': 'تم التواصل'
    };
    
    content.innerHTML = `
        <div class="contact-detail">
            <div class="contact-detail-header">
                <div class="contact-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <h3>${lead.visitorName}</h3>
                <div class="contact-expo-id">${lead.visitorExpoId}</div>
            </div>
            
            <div class="contact-detail-section">
                <h4><i class="fas fa-info-circle"></i> معلومات الزائر</h4>
                <div class="contact-info-item">
                    <span class="contact-info-label">الاسم:</span>
                    <span class="contact-info-value">${lead.visitorName}</span>
                </div>
                <div class="contact-info-item">
                    <span class="contact-info-label">ExpoID:</span>
                    <span class="contact-info-value">${lead.visitorExpoId}</span>
                </div>
                <div class="contact-info-item">
                    <span class="contact-info-label">الفئة:</span>
                    <span class="contact-info-value">${lead.category || 'غير محدد'}</span>
                </div>
                <div class="contact-info-item">
                    <span class="contact-info-label">تاريخ المسح:</span>
                    <span class="contact-info-value">${formatDate(lead.scannedAt)}</span>
                </div>
                <div class="contact-info-item">
                    <span class="contact-info-label">AI Score:</span>
                    <span class="contact-info-value">
                        <span class="ai-score ${lead.aiScore >= 70 ? 'high' : lead.aiScore >= 50 ? 'medium' : 'low'}">
                            <i class="fas fa-star"></i>
                            ${lead.aiScore}
                        </span>
                    </span>
                </div>
                <div class="contact-info-item">
                    <span class="contact-info-label">الحالة:</span>
                    <span class="contact-info-value">
                        <select id="leadStatus" onchange="updateLeadStatus('${leadId}', this.value)" style="padding: 0.5rem; border: 2px solid var(--gray-light); border-radius: var(--radius);">
                            ${Object.entries(statusOptions).map(([key, value]) => 
                                `<option value="${key}" ${lead.status === key ? 'selected' : ''}>${value}</option>`
                            ).join('')}
                        </select>
                    </span>
                </div>
            </div>
            
            <div class="contact-detail-section">
                <h4><i class="fas fa-sticky-note"></i> ملاحظاتي</h4>
                <div class="add-note-form">
                    <textarea id="leadNoteText" placeholder="اكتب ملاحظة عن هذا الزائر...">${lead.notes.join('\n')}</textarea>
                    <button class="btn btn-primary" onclick="saveLeadNote('${leadId}')" style="width: 100%;">
                        <i class="fas fa-save"></i> حفظ الملاحظة
                    </button>
                </div>
                ${lead.notes.length > 0 ? `
                <div style="margin-top: 1rem;">
                    ${lead.notes.map(note => `
                        <div class="note-item">
                            <div class="note-text">${note}</div>
                        </div>
                    `).join('')}
                </div>
                ` : ''}
            </div>
            
            <div class="contact-detail-section">
                <h4><i class="fas fa-calendar-check"></i> جدولة متابعة</h4>
                <div class="follow-up-form">
                    <div class="follow-up-options">
                        <div class="follow-up-option" onclick="selectLeadFollowUp('3days')">3 أيام</div>
                        <div class="follow-up-option" onclick="selectLeadFollowUp('1week')">أسبوع</div>
                        <div class="follow-up-option" onclick="selectLeadFollowUp('2weeks')">أسبوعان</div>
                        <div class="follow-up-option" onclick="selectLeadFollowUp('1month')">شهر</div>
                    </div>
                    <button class="btn btn-primary" onclick="saveLeadFollowUp('${leadId}')" style="width: 100%;">
                        <i class="fas fa-calendar-plus"></i> حفظ المتابعة
                    </button>
                    ${lead.followUpDate ? `
                    <p style="margin-top: 1rem; text-align: center; color: var(--success);">
                        <i class="fas fa-calendar-check"></i> متابعة مجدولة: ${formatDate(lead.followUpDate)}
                    </p>
                    ` : ''}
                </div>
            </div>
            
            <div class="form-actions" style="margin-top: 2rem;">
                <button class="btn btn-success" onclick="sendLeadMessage('${lead.visitorExpoId}')" style="flex: 1;">
                    <i class="fab fa-whatsapp"></i> إرسال رسالة
                </button>
                <button class="btn btn-outline" onclick="closeLeadModal()" style="flex: 1;">
                    إغلاق
                </button>
            </div>
        </div>
    `;
    
    modal.classList.add('show');
    selectedLeadFollowUpPeriod = null;
}

// Close Lead Modal
function closeLeadModal() {
    document.getElementById('leadModal').classList.remove('show');
}

// Update Lead Status
function updateLeadStatus(leadId, status) {
    const lead = leads.find(l => l.id === leadId);
    if (lead) {
        lead.status = status;
        localStorage.setItem('exhibitorLeads', JSON.stringify(leads));
        loadLeads();
        updateStats();
        showToast('تم تحديث الحالة بنجاح!', 'success');
    }
}

// Save Lead Note
function saveLeadNote(leadId) {
    const noteText = document.getElementById('leadNoteText').value.trim();
    
    if (!noteText) {
        showToast('يرجى إدخال نص الملاحظة', 'error');
        return;
    }
    
    const lead = leads.find(l => l.id === leadId);
    if (lead) {
        if (!lead.notes) lead.notes = [];
        lead.notes = [noteText]; // Replace with new note
        localStorage.setItem('exhibitorLeads', JSON.stringify(leads));
        showToast('تم حفظ الملاحظة بنجاح!', 'success');
        openLeadDetail(leadId);
    }
}

// Follow-up for Leads
let selectedLeadFollowUpPeriod = null;

function selectLeadFollowUp(period) {
    selectedLeadFollowUpPeriod = period;
    document.querySelectorAll('.follow-up-option').forEach(opt => {
        opt.classList.remove('selected');
    });
    event.target.classList.add('selected');
}

function saveLeadFollowUp(leadId) {
    if (!selectedLeadFollowUpPeriod) {
        showToast('يرجى اختيار فترة المتابعة', 'error');
        return;
    }
    
    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;
    
    const periods = {
        '3days': 3,
        '1week': 7,
        '2weeks': 14,
        '1month': 30
    };
    
    const days = periods[selectedLeadFollowUpPeriod];
    const followUpDate = new Date();
    followUpDate.setDate(followUpDate.getDate() + days);
    
    lead.followUpDate = followUpDate.toISOString();
    lead.status = 'follow-up';
    
    localStorage.setItem('exhibitorLeads', JSON.stringify(leads));
    loadLeads();
    updateStats();
    showToast(`تم جدولة المتابعة بعد ${days} يوم!`, 'success');
    openLeadDetail(leadId);
}

// Filter Leads
function filterLeads() {
    const searchTerm = document.getElementById('searchLeads').value.toLowerCase();
    const sortBy = document.getElementById('sortLeads').value;
    
    let filtered = [...leads];
    
    if (searchTerm) {
        filtered = filtered.filter(l => 
            l.visitorName.toLowerCase().includes(searchTerm) ||
            l.visitorExpoId.toLowerCase().includes(searchTerm) ||
            (l.category || '').toLowerCase().includes(searchTerm)
        );
    }
    
    // Sort
    if (sortBy === 'score') {
        filtered.sort((a, b) => b.aiScore - a.aiScore);
    } else if (sortBy === 'name') {
        filtered.sort((a, b) => a.visitorName.localeCompare(b.visitorName));
    } else {
        filtered.sort((a, b) => new Date(b.scannedAt) - new Date(a.scannedAt));
    }
    
    const tbody = document.getElementById('leadsTableBody');
    
    if (filtered.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" style="text-align: center; padding: 3rem; color: var(--gray);">
                    لا توجد نتائج
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = filtered.map(lead => {
        const scoreClass = lead.aiScore >= 70 ? 'high' : lead.aiScore >= 50 ? 'medium' : 'low';
        const statusText = {
            'interested': 'مهتم',
            'follow-up': 'متابعة',
            'not-interested': 'غير مهتم',
            'contacted': 'تم التواصل'
        };
        
        return `
            <tr onclick="openLeadDetail('${lead.id}')" style="cursor: pointer;">
                <td>${lead.visitorName}</td>
                <td><code>${lead.visitorExpoId}</code></td>
                <td>${formatDate(lead.scannedAt)}</td>
                <td>
                    <span class="ai-score ${scoreClass}">
                        <i class="fas fa-star"></i>
                        ${lead.aiScore}
                    </span>
                </td>
                <td>${statusText[lead.status] || lead.status}</td>
                <td>
                    <button class="action-btn" onclick="event.stopPropagation(); openLeadDetail('${lead.id}')" title="عرض التفاصيل">
                        <i class="fas fa-eye"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

// Generate Exhibitor AI Suggestions
// دور الذكاء الاصطناعي للعارض:
// 1. تحليل Leads وتحديد الأولويات بناءً على AI Score
// 2. اقتراح أفضل الأوقات للتواصل
// 3. تحليل معدل التحويل وتقديم توصيات
// 4. اقتراح نصوص متابعة مخصصة لكل Lead
// 5. تحليل أنماط التفاعل وتوقع النتائج
function generateExhibitorAISuggestions() {
    const suggestionText = document.getElementById('exhibitorAIText');
    
    if (!suggestionText) {
        console.error('❌ exhibitorAIText element not found');
        return;
    }
    
    // إعادة تحميل البيانات للتأكد
    leads = JSON.parse(localStorage.getItem('exhibitorLeads') || '[]');
    
    if (leads.length === 0) {
        suggestionText.innerHTML = `
            <div style="padding: 1rem; text-align: center; color: rgba(255, 255, 255, 0.7);">
                <i class="fas fa-info-circle" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                <p style="margin: 0;">ابدأ بجمع Leads من الزوار الذين يمسحون QR code للحصول على توصيات مخصصة</p>
            </div>
        `;
        return;
    }
    
    // تحليل البيانات وتوليد توصيات ذكية
    const highScoreLeads = leads.filter(l => l.aiScore >= 70);
    const mediumScoreLeads = leads.filter(l => l.aiScore >= 50 && l.aiScore < 70);
    const lowScoreLeads = leads.filter(l => l.aiScore < 50);
    const followUpLeads = leads.filter(l => l.followUpDate);
    const interestedLeads = leads.filter(l => l.status === 'interested' || l.status === 'follow-up');
    
    // أفضل 3 Leads للمتابعة
    const topLeads = [...leads]
        .sort((a, b) => b.aiScore - a.aiScore)
        .slice(0, 3);
    
    const conversionRate = leads.length > 0 ? Math.round((followUpLeads.length / leads.length) * 100) : 0;
    const avgScore = leads.length > 0 
        ? Math.round(leads.reduce((sum, l) => sum + l.aiScore, 0) / leads.length) 
        : 0;
    
    // بيانات افتراضية للذكاء الاصطناعي - يمكن استبدالها بـ AI حقيقي
    const aiSuggestions = [
        {
            type: 'priority',
            icon: 'fas fa-star',
            title: 'أولويات المتابعة',
            content: `لديك <strong>${highScoreLeads.length}</strong> Lead بدرجة عالية (70+) - ركّز على متابعتهم أولاً.<br>${mediumScoreLeads.length} Lead بدرجة متوسطة، و ${lowScoreLeads.length} Lead بدرجة منخفضة.`
        },
        {
            type: 'top-leads',
            icon: 'fas fa-trophy',
            title: 'أفضل 3 Leads للمتابعة',
            content: topLeads.map((lead, idx) => 
                `${idx + 1}. <strong>${lead.visitorName}</strong> (${lead.visitorExpoId}) - درجة: ${lead.aiScore}/100`
            ).join('<br>')
        },
        {
            type: 'conversion',
            icon: 'fas fa-chart-pie',
            title: 'معدل التحويل',
            content: `معدل التحويل الحالي: <strong>${conversionRate}%</strong> (${followUpLeads.length} من ${leads.length} Lead).<br>الهدف: الوصول إلى 60%+`
        },
        {
            type: 'timing',
            icon: 'fas fa-clock',
            title: 'أفضل وقت للتواصل',
            content: `بناءً على تحليل التفاعلات السابقة، أفضل وقت للتواصل هو:<br>• الصباح: 9-11 ص<br>• بعد الظهر: 2-4 م`
        },
        {
            type: 'message',
            icon: 'fas fa-comment-dots',
            title: 'نص متابعة مقترح',
            content: `"السلام عليكم، شكراً لزيارتكم جناحنا في معرض التعليم 2024. نود متابعة الحديث معكم حول فرص التعاون. هل يناسبكم مكالمة هذا الأسبوع؟"`
        },
        {
            type: 'insight',
            icon: 'fas fa-lightbulb',
            title: 'تحليل ذكي',
            content: `متوسط AI Score: <strong>${avgScore}/100</strong>.<br>${interestedLeads.length} Lead أبدوا اهتماماً. ركّز على تحويلهم إلى عملاء.`
        }
    ];
    
    // عرض التوصيات بشكل منظم
    suggestionText.innerHTML = aiSuggestions.map(suggestion => `
        <div style="background: rgba(255, 255, 255, 0.1); padding: 1rem; border-radius: 8px; margin-bottom: 0.75rem; border-right: 3px solid rgba(255, 255, 255, 0.3);">
            <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem; color: rgba(255, 255, 255, 0.9);">
                <i class="${suggestion.icon}" style="color: #FFD700;"></i>
                <strong style="font-size: 1rem;">${suggestion.title}</strong>
            </div>
            <div style="padding-right: 1.5rem; line-height: 1.8; color: rgba(255, 255, 255, 0.85); font-size: 0.9rem;">
                ${suggestion.content}
            </div>
        </div>
    `).join('');
}

// Print QR
function printQR() {
    window.print();
}

// Send Lead Message
function sendLeadMessage(expoId) {
    const message = encodeURIComponent('السلام عليكم، شكراً لزيارتكم جناحنا في المعرض. نود متابعة الحديث معكم حول فرص التعاون.');
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

// Reset Exhibitor Demo Data - إعادة تعيين البيانات الافتراضية
function resetExhibitorDemoData() {
    if (confirm('هل تريد إعادة تعيين البيانات الافتراضية؟ سيتم حذف جميع Leads الحالية.')) {
        // مسح البيانات الحالية
        localStorage.removeItem('exhibitorLeads');
        localStorage.removeItem('exhibitorHasDefaultData');
        
        // إعادة تحميل البيانات الافتراضية
        leads = [...sampleLeads];
        localStorage.setItem('exhibitorLeads', JSON.stringify(leads));
        
        // إعادة تحميل الصفحة
        loadLeads();
        updateStats();
        generateExhibitorAISuggestions();
        
        showToast('تم إعادة تعيين البيانات الافتراضية بنجاح!', 'success');
    }
}

// Load Company Info
function loadCompanyInfo() {
    const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
    const displayDiv = document.getElementById('companyInfoDisplay');
    const expoIdEl = document.getElementById('boothExpoId');
    
    if (expoIdEl && currentUser.expoId) {
        expoIdEl.textContent = currentUser.expoId;
    }
    
    if (!displayDiv) return;
    
    if (!companyInfo.companyName) {
        displayDiv.innerHTML = `
            <p style="color: var(--gray); text-align: center; padding: 2rem;">
                <i class="fas fa-info-circle" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                اضغط على "تعديل المعلومات" لإضافة معلومات الشركة والبروشور الرقمي
            </p>
        `;
        return;
    }
    
    // عرض معلومات الشركة
    displayDiv.innerHTML = `
        <div style="padding: 1rem; background: var(--gray-light); border-radius: 8px; margin-bottom: 1rem;">
            <div style="display: flex; gap: 1rem; align-items: start;">
                ${companyInfo.profileImage ? `
                <div style="flex-shrink: 0;">
                    <img src="${companyInfo.profileImage}" alt="صورة الشركة" style="width: 80px; height: 80px; border-radius: 8px; object-fit: cover; border: 2px solid var(--primary);">
                </div>
                ` : ''}
                <div style="flex: 1;">
                    <h4 style="color: var(--primary); margin-bottom: 0.5rem;">
                        <i class="fas fa-building"></i> ${companyInfo.companyName || 'غير محدد'}
                    </h4>
                    <p style="color: var(--gray); line-height: 1.8;">${companyInfo.description || 'لا يوجد وصف'}</p>
                    <div style="margin-top: 1rem; display: flex; flex-wrap: wrap; gap: 1rem;">
                        ${companyInfo.phone ? `<span><i class="fas fa-phone"></i> ${companyInfo.phone}</span>` : ''}
                        ${companyInfo.email ? `<span><i class="fas fa-envelope"></i> ${companyInfo.email}</span>` : ''}
                        ${companyInfo.website ? `<span><i class="fas fa-globe"></i> ${companyInfo.website}</span>` : ''}
                    </div>
                </div>
            </div>
        </div>
        ${companyInfo.brochure && companyInfo.brochure.title ? `
        <div style="padding: 1rem; background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%); border-radius: 8px; color: white; margin-bottom: 1rem;">
            <h4 style="color: white; margin-bottom: 0.5rem;">
                <i class="fas fa-file-pdf"></i> ${companyInfo.brochure.title}
            </h4>
            <p style="color: rgba(255, 255, 255, 0.9);">${companyInfo.brochure.description || ''}</p>
            ${companyInfo.brochure.fileUrl ? `
            <div style="margin-top: 1rem;">
                <a href="${companyInfo.brochure.fileUrl}" target="_blank" style="display: inline-flex; align-items: center; gap: 0.5rem; color: white; text-decoration: none; padding: 0.5rem 1rem; background: rgba(255, 255, 255, 0.2); border-radius: 8px; border: 1px solid white;">
                    <i class="fas fa-download"></i> تحميل البروشور (${companyInfo.brochure.fileName || 'ملف'})
                </a>
            </div>
            ` : ''}
        </div>
        ` : ''}
    `;
}

// Open Company Info Modal
function openCompanyInfoModal() {
    const modal = document.getElementById('companyInfoModal');
    const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
    
    // تعبئة البيانات الحالية إن وجدت
    if (companyInfo.companyName) {
        document.getElementById('companyNameInput').value = companyInfo.companyName || '';
        document.getElementById('companyDescription').value = companyInfo.description || '';
        document.getElementById('companyCategory').value = companyInfo.category || '';
        document.getElementById('companyPhone').value = companyInfo.phone || '';
        document.getElementById('companyEmail').value = companyInfo.email || '';
        document.getElementById('companyWebsite').value = companyInfo.website || '';
        
        if (companyInfo.brochure) {
            document.getElementById('brochureTitle').value = companyInfo.brochure.title || '';
            document.getElementById('brochureDescription').value = companyInfo.brochure.description || '';
            document.getElementById('brochureFeatures').value = companyInfo.brochure.features ? 
                (Array.isArray(companyInfo.brochure.features) ? companyInfo.brochure.features.join('\n') : companyInfo.brochure.features) : '';
            document.getElementById('brochureServices').value = companyInfo.brochure.services ? 
                (Array.isArray(companyInfo.brochure.services) ? companyInfo.brochure.services.join('\n') : companyInfo.brochure.services) : '';
        }
    } else {
        // تعبئة البيانات من currentUser إن وجدت
        if (currentUser.companyName) {
            document.getElementById('companyNameInput').value = currentUser.companyName;
        }
        if (currentUser.category) {
            document.getElementById('companyCategory').value = currentUser.category;
        }
        if (currentUser.phone) {
            document.getElementById('companyPhone').value = currentUser.phone;
        }
        if (currentUser.email) {
            document.getElementById('companyEmail').value = currentUser.email;
        }
    }
    
    modal.classList.add('show');
}

// Close Company Info Modal
function closeCompanyInfoModal() {
    document.getElementById('companyInfoModal').classList.remove('show');
}

// Save Company Info
function saveCompanyInfo(e) {
    e.preventDefault();
    
    const companyInfo = {
        companyName: document.getElementById('companyNameInput').value.trim(),
        description: document.getElementById('companyDescription').value.trim(),
        category: document.getElementById('companyCategory').value,
        phone: document.getElementById('companyPhone').value.trim(),
        email: document.getElementById('companyEmail').value.trim(),
        website: document.getElementById('companyWebsite').value.trim(),
        brochure: {
            title: document.getElementById('brochureTitle').value.trim(),
            description: document.getElementById('brochureDescription').value.trim(),
            features: document.getElementById('brochureFeatures').value
                .split(/[,\n]/)
                .map(f => f.trim())
                .filter(f => f.length > 0),
            services: document.getElementById('brochureServices').value
                .split(/[,\n]/)
                .map(s => s.trim())
                .filter(s => s.length > 0),
            brochureUrl: '#'
        },
        expoId: currentUser.expoId,
        updatedAt: new Date().toISOString()
    };
    
    // حفظ في localStorage
    localStorage.setItem('exhibitorCompanyInfo', JSON.stringify(companyInfo));
    
    // تحديث currentUser
    currentUser.companyName = companyInfo.companyName;
    currentUser.category = companyInfo.category;
    currentUser.phone = companyInfo.phone;
    currentUser.email = companyInfo.email;
    localStorage.setItem('currentUser', JSON.stringify(currentUser));
    
    // إعادة تحميل العرض
    loadCompanyInfo();
    
    // إغلاق النافذة
    closeCompanyInfoModal();
    
    showToast('تم حفظ معلومات الشركة بنجاح!', 'success');
}

// Open Profile Modal
function openProfileModal() {
    const modal = document.getElementById('profileModal');
    const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
    
    // تعبئة المعلومات الشخصية
    document.getElementById('profileFullName').value = currentUser.name || '';
    document.getElementById('profileEmail').value = currentUser.email || '';
    document.getElementById('profilePhone').value = currentUser.phone || '';
    
    // تعبئة معلومات الشركة
    document.getElementById('profileCompanyName').value = companyInfo.companyName || currentUser.companyName || '';
    document.getElementById('profileCategory').value = companyInfo.category || currentUser.category || '';
    document.getElementById('profileDescription').value = companyInfo.description || '';
    document.getElementById('profileWebsite').value = companyInfo.website || '';
    
    // تعبئة البروشور
    if (companyInfo.brochure) {
        document.getElementById('profileBrochureTitle').value = companyInfo.brochure.title || '';
        document.getElementById('profileBrochureDescription').value = companyInfo.brochure.description || '';
        document.getElementById('profileBrochureFeatures').value = companyInfo.brochure.features ? 
            (Array.isArray(companyInfo.brochure.features) ? companyInfo.brochure.features.join('\n') : companyInfo.brochure.features) : '';
        document.getElementById('profileBrochureServices').value = companyInfo.brochure.services ? 
            (Array.isArray(companyInfo.brochure.services) ? companyInfo.brochure.services.join('\n') : companyInfo.brochure.services) : '';
        
        // عرض البروشور المرفوع إن وجد
        if (companyInfo.brochure.fileUrl) {
            document.getElementById('brochureFileName').textContent = companyInfo.brochure.fileName || 'بروشور مرفوع';
            document.getElementById('brochureFileLink').href = companyInfo.brochure.fileUrl;
            document.getElementById('brochureFileLinkText').textContent = companyInfo.brochure.fileName || 'عرض البروشور';
            document.getElementById('brochureFilePreview').style.display = 'block';
            document.getElementById('removeBrochureBtn').style.display = 'inline-block';
        }
    }
    
    // عرض صورة البروفايل إن وجدت
    if (companyInfo.profileImage) {
        const imgPreview = document.getElementById('profileImagePreview');
        const imgIcon = document.getElementById('profileImageIcon');
        imgPreview.src = companyInfo.profileImage;
        imgPreview.style.display = 'block';
        imgIcon.style.display = 'none';
    } else {
        const imgPreview = document.getElementById('profileImagePreview');
        const imgIcon = document.getElementById('profileImageIcon');
        imgPreview.style.display = 'none';
        imgIcon.style.display = 'block';
    }
    
    // تحديث العرض
    document.getElementById('profileCompanyName').textContent = companyInfo.companyName || currentUser.companyName || 'اسم الشركة';
    document.getElementById('profileExpoId').textContent = currentUser.expoId || 'Expo#2048';
    document.getElementById('profileLeadsCount').textContent = leads.length;
    
    modal.classList.add('show');
}

// Handle Profile Image Upload
function handleProfileImageUpload(event) {
    const file = event.target.files[0];
    if (!file) return;
    
    // التحقق من نوع الملف
    if (!file.type.startsWith('image/')) {
        showToast('يرجى اختيار ملف صورة فقط!', 'error');
        return;
    }
    
    // التحقق من حجم الملف (10MB)
    if (file.size > 10 * 1024 * 1024) {
        showToast('حجم الصورة يجب أن يكون أقل من 10MB!', 'error');
        return;
    }
    
    // قراءة الملف وتحويله إلى Base64
    const reader = new FileReader();
    reader.onload = function(e) {
        const imageData = e.target.result;
        
        // عرض الصورة
        const imgPreview = document.getElementById('profileImagePreview');
        const imgIcon = document.getElementById('profileImageIcon');
        imgPreview.src = imageData;
        imgPreview.style.display = 'block';
        imgIcon.style.display = 'none';
        
        // حفظ الصورة في localStorage
        const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
        companyInfo.profileImage = imageData;
        companyInfo.profileImageName = file.name;
        localStorage.setItem('exhibitorCompanyInfo', JSON.stringify(companyInfo));
        
        // تحديث العرض في لوحة التحكم
        loadCompanyInfo();
        
        showToast('تم رفع صورة البروفايل بنجاح!', 'success');
    };
    reader.readAsDataURL(file);
}

// Handle Brochure File Upload
function handleBrochureFileUpload(event) {
    const file = event.target.files[0];
    if (!file) return;
    
    // التحقق من نوع الملف
    const allowedTypes = ['application/pdf', 'image/jpeg', 'image/jpg', 'image/png'];
    if (!allowedTypes.includes(file.type)) {
        showToast('يرجى اختيار ملف PDF أو صورة (JPG, PNG) فقط!', 'error');
        return;
    }
    
    // التحقق من حجم الملف (10MB)
    if (file.size > 10 * 1024 * 1024) {
        showToast('حجم الملف يجب أن يكون أقل من 10MB!', 'error');
        return;
    }
    
    // قراءة الملف وتحويله إلى Base64
    const reader = new FileReader();
    reader.onload = function(e) {
        const fileData = e.target.result;
        
        // عرض معلومات الملف
        document.getElementById('brochureFileName').textContent = file.name;
        document.getElementById('brochureFileLink').href = fileData;
        document.getElementById('brochureFileLinkText').textContent = file.name;
        document.getElementById('brochureFilePreview').style.display = 'block';
        document.getElementById('removeBrochureBtn').style.display = 'inline-block';
        
        // حفظ الملف في localStorage
        const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
        if (!companyInfo.brochure) {
            companyInfo.brochure = {};
        }
        companyInfo.brochure.fileUrl = fileData;
        companyInfo.brochure.fileName = file.name;
        companyInfo.brochure.fileType = file.type;
        localStorage.setItem('exhibitorCompanyInfo', JSON.stringify(companyInfo));
        
        showToast('تم رفع البروشور بنجاح!', 'success');
    };
    reader.readAsDataURL(file);
}

// Remove Brochure File
function removeBrochureFile() {
    if (confirm('هل تريد إزالة البروشور المرفوع؟')) {
        const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
        if (companyInfo.brochure) {
            companyInfo.brochure.fileUrl = null;
            companyInfo.brochure.fileName = null;
            companyInfo.brochure.fileType = null;
        }
        localStorage.setItem('exhibitorCompanyInfo', JSON.stringify(companyInfo));
        
        // إعادة تعيين العرض
        document.getElementById('brochureFileName').textContent = 'لم يتم اختيار ملف';
        document.getElementById('brochureFilePreview').style.display = 'none';
        document.getElementById('removeBrochureBtn').style.display = 'none';
        document.getElementById('brochureFileUpload').value = '';
        
        showToast('تم إزالة البروشور بنجاح!', 'success');
    }
}

// Close Profile Modal
function closeProfileModal() {
    document.getElementById('profileModal').classList.remove('show');
}

// Save Profile Personal Info
function saveProfilePersonal(e) {
    e.preventDefault();
    
    currentUser.name = document.getElementById('profileFullName').value.trim();
    currentUser.email = document.getElementById('profileEmail').value.trim();
    currentUser.phone = document.getElementById('profilePhone').value.trim();
    
    localStorage.setItem('currentUser', JSON.stringify(currentUser));
    
    // تحديث العرض
    document.getElementById('profileCompanyName').textContent = currentUser.companyName || 'اسم الشركة';
    
    showToast('تم حفظ المعلومات الشخصية بنجاح!', 'success');
}

// Save Profile Company Info
function saveProfileCompany(e) {
    e.preventDefault();
    
    const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
    
    companyInfo.companyName = document.getElementById('profileCompanyName').value.trim();
    companyInfo.category = document.getElementById('profileCategory').value;
    companyInfo.description = document.getElementById('profileDescription').value.trim();
    companyInfo.website = document.getElementById('profileWebsite').value.trim();
    companyInfo.expoId = currentUser.expoId;
    companyInfo.updatedAt = new Date().toISOString();
    
    // تحديث currentUser
    currentUser.companyName = companyInfo.companyName;
    currentUser.category = companyInfo.category;
    currentUser.email = document.getElementById('profileEmail').value.trim();
    currentUser.phone = document.getElementById('profilePhone').value.trim();
    
    localStorage.setItem('exhibitorCompanyInfo', JSON.stringify(companyInfo));
    localStorage.setItem('currentUser', JSON.stringify(currentUser));
    
    // تحديث العرض
    loadCompanyInfo();
    document.getElementById('profileCompanyName').textContent = companyInfo.companyName;
    
    showToast('تم حفظ معلومات الشركة بنجاح!', 'success');
}

// Save Profile Brochure
function saveProfileBrochure(e) {
    e.preventDefault();
    
    const companyInfo = JSON.parse(localStorage.getItem('exhibitorCompanyInfo') || '{}');
    
    if (!companyInfo.brochure) {
        companyInfo.brochure = {};
    }
    
    // الحفاظ على الملف المرفوع إن وجد
    const existingFile = companyInfo.brochure.fileUrl;
    const existingFileName = companyInfo.brochure.fileName;
    const existingFileType = companyInfo.brochure.fileType;
    
    companyInfo.brochure.title = document.getElementById('profileBrochureTitle').value.trim();
    companyInfo.brochure.description = document.getElementById('profileBrochureDescription').value.trim();
    companyInfo.brochure.features = document.getElementById('profileBrochureFeatures').value
        .split(/[,\n]/)
        .map(f => f.trim())
        .filter(f => f.length > 0);
    companyInfo.brochure.services = document.getElementById('profileBrochureServices').value
        .split(/[,\n]/)
        .map(s => s.trim())
        .filter(s => s.length > 0);
    
    // استعادة الملف المرفوع
    if (existingFile) {
        companyInfo.brochure.fileUrl = existingFile;
        companyInfo.brochure.fileName = existingFileName;
        companyInfo.brochure.fileType = existingFileType;
    } else {
        companyInfo.brochure.brochureUrl = '#';
    }
    
    companyInfo.expoId = currentUser.expoId;
    companyInfo.updatedAt = new Date().toISOString();
    
    localStorage.setItem('exhibitorCompanyInfo', JSON.stringify(companyInfo));
    
    // تحديث العرض
    loadCompanyInfo();
    
    showToast('تم حفظ البروشور بنجاح!', 'success');
}

// Save Profile Security
function saveProfileSecurity(e) {
    e.preventDefault();
    
    const newPassword = document.getElementById('profileNewPassword').value;
    const confirmPassword = document.getElementById('profileConfirmPassword').value;
    
    if (newPassword && newPassword !== confirmPassword) {
        showToast('كلمة المرور الجديدة غير متطابقة!', 'error');
        return;
    }
    
    if (newPassword && newPassword.length < 6) {
        showToast('كلمة المرور يجب أن تكون 6 أحرف على الأقل!', 'error');
        return;
    }
    
    // في التطبيق الحقيقي، سيتم التحقق من كلمة المرور الحالية وإرسالها للسيرفر
    if (newPassword) {
        currentUser.password = newPassword; // في التطبيق الحقيقي، يجب تشفير كلمة المرور
        localStorage.setItem('currentUser', JSON.stringify(currentUser));
        showToast('تم تحديث كلمة المرور بنجاح!', 'success');
        
        // مسح الحقول
        document.getElementById('profileCurrentPassword').value = '';
        document.getElementById('profileNewPassword').value = '';
        document.getElementById('profileConfirmPassword').value = '';
    } else {
        showToast('يرجى إدخال كلمة مرور جديدة', 'error');
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

