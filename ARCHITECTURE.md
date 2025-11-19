# 🏗️ Smart Card - Architecture Diagram
## مخطط معماري للتطبيق

---

## 📐 نظرة عامة على الطبقات (Layered Architecture)

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  (UI - Screens, Widgets, State Management)                   │
├─────────────────────────────────────────────────────────────┤
│                    BUSINESS LOGIC LAYER                      │
│  (Services, Use Cases, Business Rules)                       │
├─────────────────────────────────────────────────────────────┤
│                    DATA LAYER                                │
│  (Models, Storage, API, Cache)                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 الطبقة الأولى: Presentation Layer (واجهة المستخدم)

### المكونات:
```
lib/
├── screens/              # الشاشات الرئيسية
│   ├── home/           # الصفحة الرئيسية
│   ├── auth/           # تسجيل الدخول/التسجيل
│   ├── visitor_dashboard/  # لوحة تحكم الزائر
│   └── exhibitor_dashboard/ # لوحة تحكم العارض
│
├── widgets/             # مكونات UI قابلة لإعادة الاستخدام
│   ├── buttons/        # أزرار مخصصة
│   ├── cards/          # بطاقات
│   ├── modals/         # نوافذ منبثقة
│   ├── forms/          # نماذج
│   └── common/         # مكونات مشتركة
│
└── config/
    ├── theme.dart      # الثيمات والألوان
    ├── routes.dart     # مسارات التطبيق
    └── constants.dart  # الثوابت
```

### المسؤوليات:
- ✅ عرض البيانات للمستخدم
- ✅ استقبال إدخال المستخدم
- ✅ إدارة حالة الواجهة (Provider)
- ✅ التنقل بين الشاشات
- ✅ التحقق من صحة المدخلات (UI level)

---

## 🧠 الطبقة الثانية: Business Logic Layer (منطق العمل)

### المكونات:
```
lib/
├── services/            # الخدمات
│   ├── auth_service.dart      # خدمة المصادقة
│   ├── storage_service.dart   # خدمة التخزين
│   ├── qr_service.dart        # خدمة QR Code
│   ├── contact_service.dart   # خدمة جهات الاتصال
│   └── ai_service.dart        # خدمة AI (للمستقبل)
│
└── providers/          # State Management
    ├── auth_provider.dart
    ├── visitor_provider.dart
    └── exhibitor_provider.dart
```

### المسؤوليات:
- ✅ تنفيذ قواعد العمل
- ✅ معالجة البيانات
- ✅ إدارة الحالة (State Management)
- ✅ التنسيق بين الطبقات
- ✅ التحقق من صحة البيانات (Business level)

---

## 💾 الطبقة الثالثة: Data Layer (البيانات)

### المكونات:
```
lib/
├── models/             # نماذج البيانات
│   ├── user.dart
│   ├── contact.dart
│   ├── lead.dart
│   ├── note.dart
│   └── follow_up.dart
│
├── repositories/      # مستودعات البيانات (للمستقبل)
│   ├── user_repository.dart
│   └── contact_repository.dart
│
└── utils/
    ├── storage_helper.dart    # SharedPreferences wrapper
    └── api_helper.dart        # API calls (للمستقبل)
```

### المسؤوليات:
- ✅ تخزين البيانات محلياً
- ✅ جلب البيانات من API (للمستقبل)
- ✅ تحويل البيانات (Models ↔ JSON)
- ✅ إدارة Cache
- ✅ معالجة الأخطاء

---

## 🔄 تدفق البيانات (Data Flow)

### مثال: مسح QR Code

```
1. User Action (UI)
   └─> User taps "Scan QR" button
       │
2. Presentation Layer
   └─> Screen calls QRService.scan()
       │
3. Business Logic Layer
   └─> QRService processes QR data
       └─> ContactService.createContact()
           │
4. Data Layer
   └─> StorageService.saveContact()
       └─> Save to SharedPreferences
           │
5. State Update
   └─> Provider notifies listeners
       │
6. UI Update
   └─> Screen rebuilds with new data
```

---

## 🎨 Theme System (نظام الثيمات)

### الهيكل:
```
config/theme.dart
├── AppTheme (Class)
│   ├── lightTheme (ThemeData)
│   │   ├── Colors
│   │   ├── Text Styles
│   │   ├── Button Styles
│   │   └── Card Styles
│   │
│   ├── darkTheme (ThemeData)
│   │   └── (نفس الهيكل)
│   │
│   └── AppColors (Class)
│       ├── Primary Colors
│       ├── Secondary Colors
│       ├── Status Colors
│       └── Neutral Colors
│
└── AppTextStyles (Class)
    ├── Headings
    ├── Body
    └── Labels
```

---

## 🔐 Security Layers (طبقات الأمان)

### 1. Authentication Layer
- التحقق من الهوية
- إدارة الجلسات
- Tokens

### 2. Data Encryption Layer
- تشفير البيانات الحساسة
- Secure Storage

### 3. Validation Layer
- التحقق من المدخلات
- Sanitization

---

## 📱 Screen Flow (تدفق الشاشات)

### Visitor Flow:
```
Home Screen
    ↓
[Scan QR] → QR Scanner → Contact Detail → [Save Contact]
    ↓
Visitor Dashboard → Contacts List → Contact Detail
    ↓
[Add Note] → Note Form → Save
    ↓
[Schedule Follow-up] → Follow-up Form → Save
```

### Exhibitor Flow:
```
Home Screen
    ↓
Exhibitor Dashboard → Leads List → Lead Detail
    ↓
[View Profile] → Profile Screen → [Edit Profile]
    ↓
[Company Info] → Company Info Form → Save
    ↓
[QR Code] → Generate QR → Print/Share
```

---

## 🔌 Integration Points (نقاط التكامل)

### Current (MVP):
- ✅ Local Storage (SharedPreferences)
- ✅ QR Code Scanner (mobile_scanner)
- ✅ QR Code Generator (qr_flutter)

### Future:
- 🔄 Firebase Auth
- 🔄 Firestore Database
- 🔄 Cloud Functions
- 🔄 AI Services (Whisper, GPT)
- 🔄 Vector DB (Pinecone)

---

## 📊 State Management Flow

```
User Action
    ↓
Provider (State Management)
    ↓
Service (Business Logic)
    ↓
Storage/API (Data Layer)
    ↓
Provider Update
    ↓
UI Rebuild
```

---

## 🧪 Testing Strategy

### Unit Tests:
- Models
- Services
- Utils

### Widget Tests:
- Screens
- Widgets
- Forms

### Integration Tests:
- User Flows
- Navigation
- Data Persistence

---

## 📈 Scalability Considerations

### Current (MVP):
- Simple structure
- Local storage only
- Basic state management

### Future Scaling:
- Feature-based structure
- Domain/Repository pattern
- Microservices backend
- Caching layer
- Offline-first architecture

---

## 🎯 Key Principles

1. **Separation of Concerns**: كل طبقة لها مسؤولية واحدة
2. **Single Source of Truth**: Provider يدير الحالة
3. **Reusability**: Widgets قابلة لإعادة الاستخدام
4. **Testability**: كل طبقة قابلة للاختبار منفصلة
5. **Maintainability**: هيكل واضح وسهل الصيانة

---

## 📝 Notes

- هذا الهيكل مصمم للمرحلة الأولى (MVP)
- يمكن التوسع لاحقاً حسب الحاجة
- جميع المكونات قابلة للتعديل والتوسع

