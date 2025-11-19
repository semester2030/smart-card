# دليل الأيقونات - ExpoCard

## 📍 أماكن ظهور الأيقونات

### الصفحة الرئيسية (index.html)

#### في Navigation:
- `<i class="fas fa-id-card"></i>` - أيقونة ExpoCard في الشعار

#### في Hero Section:
- `<i class="fas fa-rocket"></i>` - زر "ابدأ الآن مجاناً"
- `<i class="fas fa-eye"></i>` - زر "تجربة كزائر"

#### في Features Section:
- `<i class="fas fa-qrcode"></i>` - مسح QR
- `<i class="fas fa-brain"></i>` - مساعد AI
- `<i class="fas fa-calendar-check"></i>` - متابعة تلقائية
- `<i class="fas fa-chart-line"></i>` - تحليلات متقدمة
- `<i class="fas fa-microphone"></i>` - ملاحظات صوتية
- `<i class="fas fa-globe"></i>` - معارض متعددة

#### في User Types:
- `<i class="fas fa-user"></i>` - أيقونة الزائر
- `<i class="fas fa-building"></i>` - أيقونة العارض

---

### لوحة تحكم الزائر (visitor-dashboard.html)

#### في Header:
- `<i class="fas fa-user"></i>` - أيقونة لوحة تحكم الزائر
- `<i class="fas fa-sync"></i>` - زر إعادة تعيين
- `<i class="fas fa-home"></i>` - زر الصفحة الرئيسية

#### في Statistics Cards:
- `<i class="fas fa-address-book"></i>` - جهات الاتصال
- `<i class="fas fa-sticky-note"></i>` - الملاحظات
- `<i class="fas fa-calendar-check"></i>` - المتابعات

#### في QR Scanner:
- `<i class="fas fa-qrcode"></i>` - عنوان مسح QR
- `<i class="fas fa-camera"></i>` - أيقونة الكاميرا في الماسح
- `<i class="fas fa-search"></i>` - زر البحث

#### في AI Assistant:
- `<i class="fas fa-brain"></i>` - عنوان مساعد ExpoAI
- `<i class="fas fa-lightbulb"></i>` - اقتراحات ذكية
- `<i class="fas fa-sync"></i>` - زر تحديث الاقتراحات

#### في Contacts List:
- `<i class="fas fa-calendar-plus"></i>` - زر جدولة متابعة
- `<i class="fas fa-sticky-note"></i>` - زر إضافة ملاحظة

#### في Contact Detail Modal:
- `<i class="fas fa-building"></i>` - أيقونة الشركة
- `<i class="fas fa-info-circle"></i>` - معلومات الاتصال
- `<i class="fas fa-align-right"></i>` - الوصف
- `<i class="fas fa-sticky-note"></i>` - إضافة ملاحظة
- `<i class="fas fa-microphone"></i>` - ملاحظة صوتية
- `<i class="fas fa-save"></i>` - حفظ
- `<i class="fas fa-list"></i>` - الملاحظات
- `<i class="fas fa-calendar-check"></i>` - جدولة متابعة
- `<i class="fas fa-calendar-plus"></i>` - حفظ المتابعة
- `<i class="fab fa-whatsapp"></i>` - واتساب

---

### لوحة تحكم العارض (exhibitor-dashboard.html)

#### في Header:
- `<i class="fas fa-building"></i>` - أيقونة لوحة تحكم العارض
- `<i class="fas fa-sync"></i>` - زر إعادة تعيين
- `<i class="fas fa-home"></i>` - زر الصفحة الرئيسية

#### في Statistics Cards:
- `<i class="fas fa-users"></i>` - Leads
- `<i class="fas fa-qrcode"></i>` - المسحات
- `<i class="fas fa-chart-line"></i>` - معدل التحويل
- `<i class="fas fa-star"></i>` - متوسط الاهتمام

#### في QR Code Section:
- `<i class="fas fa-qrcode"></i>` - عنوان QR Code الجناح
- `<i class="fas fa-print"></i>` - زر طباعة QR

#### في Leads Table:
- `<i class="fas fa-star"></i>` - AI Score
- `<i class="fas fa-eye"></i>` - عرض التفاصيل

#### في Lead Detail Modal:
- `<i class="fas fa-user"></i>` - أيقونة الزائر
- `<i class="fas fa-info-circle"></i>` - معلومات الزائر
- `<i class="fas fa-star"></i>` - AI Score
- `<i class="fas fa-sticky-note"></i>` - ملاحظاتي
- `<i class="fas fa-save"></i>` - حفظ الملاحظة
- `<i class="fas fa-calendar-check"></i>` - جدولة متابعة
- `<i class="fas fa-calendar-plus"></i>` - حفظ المتابعة
- `<i class="fab fa-whatsapp"></i>` - إرسال رسالة

#### في Analytics:
- `<i class="fas fa-chart-bar"></i>` - إحصائيات اليوم
- `<i class="fas fa-map-marked-alt"></i>` - مصادر الزوار

#### في AI Assistant:
- `<i class="fas fa-brain"></i>` - عنوان مساعد ExpoAI
- `<i class="fas fa-lightbulb"></i>` - توصيات ذكية
- `<i class="fas fa-sync"></i>` - زر تحديث التوصيات

---

## 🔧 حل مشاكل الأيقونات

### إذا لم تظهر الأيقونات:

1. **تحقق من الاتصال بالإنترنت**
   - Font Awesome يتم تحميله من CDN
   - يحتاج اتصال بالإنترنت

2. **تحقق من Console (F12)**
   - افتح Developer Tools
   - تحقق من وجود أخطاء في تحميل Font Awesome

3. **جرب تحديث الصفحة**
   - اضغط Ctrl+F5 (أو Cmd+Shift+R على Mac)

4. **تحقق من الرابط**
   - الرابط الحالي: `https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css`
   - تأكد من أنه يعمل

---

## 📦 Font Awesome المستخدم

- **الإصدار**: 6.4.0
- **المصدر**: CDN (cdnjs.cloudflare.com)
- **النوع**: Font Awesome Solid (fas) و Brands (fab)

---

## 🎨 الأيقونات الرئيسية المستخدمة

| الأيقون | الاستخدام |
|---------|-----------|
| `fa-user` | المستخدم/الزائر |
| `fa-building` | الشركة/العارض |
| `fa-qrcode` | QR Code |
| `fa-brain` | AI |
| `fa-calendar-check` | المتابعات |
| `fa-sticky-note` | الملاحظات |
| `fa-address-book` | جهات الاتصال |
| `fa-chart-line` | التحليلات |
| `fa-star` | AI Score |
| `fa-whatsapp` | واتساب |

---

**جميع الأيقونات من Font Awesome 6.4.0**

