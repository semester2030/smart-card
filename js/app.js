// Main App JavaScript
// المتغيرات المشتركة - يتم تعريفها فقط في الصفحة الرئيسية
// في لوحات التحكم، يتم تعريفها في ملفاتها الخاصة
let currentUser = null;

// Initialize App
document.addEventListener('DOMContentLoaded', function() {
    loadUser();
    setupEventListeners();
});

// Load User from localStorage
function loadUser() {
    const savedUser = localStorage.getItem('currentUser');
    if (savedUser) {
        currentUser = JSON.parse(savedUser);
    }
}

// Setup Event Listeners
function setupEventListeners() {
    // Auth form switching
    const authSwitches = document.querySelectorAll('.auth-switch a');
    authSwitches.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const type = this.dataset.type;
            if (type) {
                showAuthModal(type);
            }
        });
    });
}

// Show Auth Modal
function showAuthModal(type = 'login') {
    const modal = document.getElementById('authModal');
    const content = document.getElementById('authContent');
    
    if (type === 'login') {
        content.innerHTML = `
            <div class="auth-form">
                <h2>تسجيل الدخول</h2>
                <form onsubmit="handleLogin(event)">
                    <div class="form-group">
                        <label>البريد الإلكتروني أو ExpoID</label>
                        <input type="text" id="loginId" required>
                    </div>
                    <div class="form-group">
                        <label>كلمة المرور</label>
                        <input type="password" id="loginPassword" required>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">تسجيل الدخول</button>
                    </div>
                </form>
                <div class="auth-switch">
                    ليس لديك حساب؟ <a href="#" data-type="register" onclick="showAuthModal('register')">سجّل الآن</a>
                </div>
            </div>
        `;
    } else {
        content.innerHTML = `
            <div class="auth-form">
                <h2>إنشاء حساب جديد</h2>
                <form onsubmit="handleRegister(event)">
                    <div class="form-group">
                        <label>نوع المستخدم</label>
                        <select id="userRole" required onchange="toggleRoleFields()">
                            <option value="">اختر نوع المستخدم</option>
                            <option value="visitor">زائر</option>
                            <option value="exhibitor">عارض / شركة</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>الاسم الكامل</label>
                        <input type="text" id="fullName" required>
                    </div>
                    <div class="form-group" id="companyNameGroup" style="display: none;">
                        <label>اسم الشركة</label>
                        <input type="text" id="companyName">
                    </div>
                    <div class="form-group">
                        <label>البريد الإلكتروني</label>
                        <input type="email" id="email" required>
                    </div>
                    <div class="form-group">
                        <label>رقم الجوال</label>
                        <input type="tel" id="phone" required>
                    </div>
                    <div class="form-group">
                        <label>كلمة المرور</label>
                        <input type="password" id="password" required>
                    </div>
                    <div class="form-group" id="interestsGroup" style="display: none;">
                        <label>الاهتمامات (اختياري)</label>
                        <div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.5rem;">
                            <label style="display: flex; align-items: center; gap: 0.5rem;">
                                <input type="checkbox" value="تعليم"> تعليم
                            </label>
                            <label style="display: flex; align-items: center; gap: 0.5rem;">
                                <input type="checkbox" value="نقل"> نقل
                            </label>
                            <label style="display: flex; align-items: center; gap: 0.5rem;">
                                <input type="checkbox" value="استثمار"> استثمار
                            </label>
                            <label style="display: flex; align-items: center; gap: 0.5rem;">
                                <input type="checkbox" value="تقنية"> تقنية
                            </label>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">إنشاء حساب</button>
                    </div>
                </form>
                <div class="auth-switch">
                    لديك حساب بالفعل؟ <a href="#" data-type="login" onclick="showAuthModal('login')">سجّل الدخول</a>
                </div>
            </div>
        `;
    }
    
    modal.classList.add('show');
}

// Close Auth Modal
function closeAuthModal() {
    const modal = document.getElementById('authModal');
    modal.classList.remove('show');
}

// Toggle Role Fields
function toggleRoleFields() {
    const role = document.getElementById('userRole').value;
    const companyGroup = document.getElementById('companyNameGroup');
    const interestsGroup = document.getElementById('interestsGroup');
    
    if (role === 'exhibitor') {
        companyGroup.style.display = 'block';
    } else {
        companyGroup.style.display = 'none';
    }
    
    if (role === 'visitor') {
        interestsGroup.style.display = 'block';
    } else {
        interestsGroup.style.display = 'none';
    }
}

// Handle Register
function handleRegister(e) {
    e.preventDefault();
    
    const role = document.getElementById('userRole').value;
    const fullName = document.getElementById('fullName').value;
    const companyName = document.getElementById('companyName').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const password = document.getElementById('password').value;
    
    // Generate ExpoID
    const expoId = generateExpoID();
    
    // Get interests if visitor
    const interests = [];
    if (role === 'visitor') {
        document.querySelectorAll('#interestsGroup input[type="checkbox"]:checked').forEach(cb => {
            interests.push(cb.value);
        });
    }
    
    const user = {
        id: Date.now().toString(),
        expoId: expoId,
        name: fullName,
        email: email,
        phone: phone,
        role: role,
        companyName: companyName || null,
        interests: interests,
        createdAt: new Date().toISOString()
    };
    
    // Save user
    localStorage.setItem('currentUser', JSON.stringify(user));
    localStorage.setItem('users', JSON.stringify([...(JSON.parse(localStorage.getItem('users') || '[]')), user]));
    
    currentUser = user;
    
    // Redirect based on role
    closeAuthModal();
    setTimeout(() => {
        if (role === 'visitor') {
            window.location.href = 'visitor-dashboard.html';
        } else if (role === 'exhibitor') {
            window.location.href = 'exhibitor-dashboard.html';
        }
    }, 500);
}

// Handle Login
function handleLogin(e) {
    e.preventDefault();
    
    const loginId = document.getElementById('loginId').value;
    const password = document.getElementById('loginPassword').value;
    
    // Simple login check (in real app, this would be server-side)
    const users = JSON.parse(localStorage.getItem('users') || '[]');
    const user = users.find(u => u.email === loginId || u.expoId === loginId);
    
    if (user) {
        localStorage.setItem('currentUser', JSON.stringify(user));
        currentUser = user;
        closeAuthModal();
        
        setTimeout(() => {
            if (user.role === 'visitor') {
                window.location.href = 'visitor-dashboard.html';
            } else if (user.role === 'exhibitor') {
                window.location.href = 'exhibitor-dashboard.html';
            }
        }, 500);
    } else {
        alert('بيانات الدخول غير صحيحة');
    }
}

// Generate ExpoID
function generateExpoID() {
    const num = Math.floor(Math.random() * 9000) + 1000;
    return `Expo#${num}`;
}

// Toggle Navigation
function toggleNav() {
    const navMenu = document.querySelector('.nav-menu');
    navMenu.classList.toggle('active');
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('authModal');
    if (event.target === modal) {
        closeAuthModal();
    }
}

