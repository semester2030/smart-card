const sgMail = require('@sendgrid/mail');

// Initialize SendGrid
if (process.env.SENDGRID_API_KEY) {
  sgMail.setApiKey(process.env.SENDGRID_API_KEY);
}

/**
 * Check if email is configured
 */
const isEmailConfigured = () => {
  return !!process.env.SENDGRID_API_KEY && process.env.SENDGRID_API_KEY !== 'YOUR_SENDGRID_API_KEY';
};

/**
 * Send OTP email
 * @param {string} email - Recipient email
 * @param {string} otp - OTP code
 * @param {string} name - User name (optional)
 */
const sendOTPEmail = async (email, otp, name = '') => {
  if (!isEmailConfigured()) {
    console.warn('⚠️ Email not configured. OTP will only appear in console.');
    console.log(`⚠️ OTP for ${email}: ${otp}`);
    return { success: false, message: 'Email not configured' };
  }

  try {
    const msg = {
      to: email,
      from: process.env.SENDGRID_FROM_EMAIL || 'noreply@smartcard.com',
      subject: 'رمز التحقق - Smart Card',
      html: `
        <!DOCTYPE html>
        <html dir="rtl" lang="ar">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              direction: rtl;
              text-align: right;
              background-color: #f5f5f5;
              margin: 0;
              padding: 0;
            }
            .container {
              max-width: 600px;
              margin: 20px auto;
              background-color: #ffffff;
              border-radius: 10px;
              overflow: hidden;
              box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .header {
              background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%);
              color: white;
              padding: 30px;
              text-align: center;
            }
            .header h1 {
              margin: 0;
              font-size: 28px;
              font-weight: bold;
            }
            .content {
              padding: 40px 30px;
            }
            .otp-box {
              background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%);
              color: white;
              padding: 30px;
              border-radius: 10px;
              text-align: center;
              margin: 30px 0;
            }
            .otp-code {
              font-size: 48px;
              font-weight: bold;
              letter-spacing: 10px;
              margin: 20px 0;
              font-family: 'Courier New', monospace;
            }
            .message {
              font-size: 16px;
              line-height: 1.6;
              color: #333;
              margin: 20px 0;
            }
            .warning {
              background-color: #FEF3C7;
              border-right: 4px solid #F59E0B;
              padding: 15px;
              border-radius: 5px;
              margin: 20px 0;
              color: #92400E;
            }
            .footer {
              background-color: #F9FAFB;
              padding: 20px;
              text-align: center;
              color: #6B7280;
              font-size: 14px;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>🔐 رمز التحقق</h1>
            </div>
            <div class="content">
              <p class="message">
                ${name ? `مرحباً ${name},` : 'مرحباً،'}<br><br>
                شكراً لتسجيلك في تطبيق Smart Card. استخدم الرمز التالي للتحقق من حسابك:
              </p>
              
              <div class="otp-box">
                <div style="font-size: 18px; margin-bottom: 10px;">رمز التحقق الخاص بك</div>
                <div class="otp-code" style="font-size: 48px; font-weight: bold; letter-spacing: 10px; margin: 20px 0; font-family: 'Courier New', monospace; color: white; background-color: rgba(255,255,255,0.2); padding: 20px; border-radius: 8px; display: inline-block; min-width: 300px;">${otp}</div>
                <div style="font-size: 14px; opacity: 0.9; margin-top: 10px;">صالح لمدة 10 دقائق</div>
              </div>
              <!-- Fallback text for email clients that don't support HTML -->
              <p style="font-size: 20px; font-weight: bold; text-align: center; color: #2563EB; margin: 30px 0; padding: 20px; background-color: #EFF6FF; border-radius: 8px;">
                رمز التحقق: <strong style="font-size: 32px; letter-spacing: 5px; font-family: monospace;">${otp}</strong>
              </p>
              
              <div class="warning">
                ⚠️ <strong>تنبيه:</strong> لا تشارك هذا الرمز مع أي شخص. لن يطلب منك فريق Smart Card إرسال هذا الرمز أبداً.
              </div>
              
              <p class="message">
                إذا لم تطلب هذا الرمز، يرجى تجاهل هذه الرسالة.
              </p>
            </div>
            <div class="footer">
              <p>© 2024 Smart Card. جميع الحقوق محفوظة.</p>
              <p>هذه رسالة تلقائية، يرجى عدم الرد عليها.</p>
            </div>
          </div>
        </body>
        </html>
      `,
      text: `
رمز التحقق - Smart Card

${name ? `مرحباً ${name},` : 'مرحباً،'}

شكراً لتسجيلك في تطبيق Smart Card. استخدم الرمز التالي للتحقق من حسابك:

═══════════════════════════════════
   رمز التحقق: ${otp}
═══════════════════════════════════

هذا الرمز صالح لمدة 10 دقائق.

⚠️ تنبيه: لا تشارك هذا الرمز مع أي شخص. لن يطلب منك فريق Smart Card إرسال هذا الرمز أبداً.

إذا لم تطلب هذا الرمز، يرجى تجاهل هذه الرسالة.

شكراً لك،
فريق Smart Card

© 2024 Smart Card. جميع الحقوق محفوظة.
هذه رسالة تلقائية، يرجى عدم الرد عليها.
      `,
    };

    await sgMail.send(msg);
    console.log(`✅ OTP email sent successfully to ${email}`);
    return { success: true };
  } catch (error) {
    console.error('❌ Error sending email:', error);
    console.error('❌ Error details:', JSON.stringify(error.response?.body || error, null, 2));
    // Fallback to console
    console.log(`⚠️ OTP for ${email}: ${otp} (Email failed, check console)`);
    return { success: false, message: error.message || 'Failed to send email' };
  }
};

/**
 * Send welcome email after successful verification
 */
const sendWelcomeEmail = async (email, name) => {
  if (!isEmailConfigured()) {
    return; // Skip if not configured
  }

  try {
    const msg = {
      to: email,
      from: process.env.SENDGRID_FROM_EMAIL || 'noreply@smartcard.com',
      subject: 'مرحباً بك في Smart Card',
      html: `
        <!DOCTYPE html>
        <html dir="rtl" lang="ar">
        <head>
          <meta charset="UTF-8">
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              direction: rtl;
              text-align: right;
              background-color: #f5f5f5;
              margin: 0;
              padding: 0;
            }
            .container {
              max-width: 600px;
              margin: 20px auto;
              background-color: #ffffff;
              border-radius: 10px;
              overflow: hidden;
              box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .header {
              background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%);
              color: white;
              padding: 30px;
              text-align: center;
            }
            .content {
              padding: 40px 30px;
            }
            .message {
              font-size: 16px;
              line-height: 1.6;
              color: #333;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>🎉 مرحباً بك!</h1>
            </div>
            <div class="content">
              <p class="message">
                مرحباً ${name},<br><br>
                تم التحقق من حسابك بنجاح! أنت الآن جاهز لاستخدام تطبيق Smart Card.
              </p>
            </div>
          </div>
        </body>
        </html>
      `
    };

    await sgMail.send(msg);
    console.log(`✅ Welcome email sent to ${email}`);
  } catch (error) {
    console.error('❌ Error sending welcome email:', error);
    // Don't throw - welcome email is not critical
  }
};

/**
 * Send password reset email
 */
const sendPasswordResetEmail = async (email, otp, name = '') => {
  if (!isEmailConfigured()) {
    console.warn('⚠️ Email not configured. Password reset OTP will only appear in console.');
    console.log(`⚠️ Password reset OTP for ${email}: ${otp}`);
    return { success: false, message: 'Email not configured' };
  }

  try {
    const msg = {
      to: email,
      from: process.env.SENDGRID_FROM_EMAIL || 'noreply@smartcard.com',
      subject: 'إعادة تعيين كلمة المرور - Smart Card',
      html: `
        <!DOCTYPE html>
        <html dir="rtl" lang="ar">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              direction: rtl;
              text-align: right;
              background-color: #f5f5f5;
              margin: 0;
              padding: 0;
            }
            .container {
              max-width: 600px;
              margin: 20px auto;
              background-color: #ffffff;
              border-radius: 10px;
              overflow: hidden;
              box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .header {
              background: linear-gradient(135deg, #DC2626 0%, #B91C1C 100%);
              color: white;
              padding: 30px;
              text-align: center;
            }
            .header h1 {
              margin: 0;
              font-size: 28px;
              font-weight: bold;
            }
            .content {
              padding: 40px 30px;
            }
            .otp-box {
              background: linear-gradient(135deg, #DC2626 0%, #B91C1C 100%);
              color: white;
              padding: 30px;
              border-radius: 10px;
              text-align: center;
              margin: 30px 0;
            }
            .otp-code {
              font-size: 48px;
              font-weight: bold;
              letter-spacing: 10px;
              margin: 20px 0;
              font-family: 'Courier New', monospace;
            }
            .message {
              font-size: 16px;
              line-height: 1.6;
              color: #333;
              margin: 20px 0;
            }
            .warning {
              background-color: #FEE2E2;
              border-right: 4px solid #DC2626;
              padding: 15px;
              border-radius: 5px;
              margin: 20px 0;
              color: #991B1B;
            }
            .footer {
              background-color: #F9FAFB;
              padding: 20px;
              text-align: center;
              color: #6B7280;
              font-size: 14px;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>🔒 إعادة تعيين كلمة المرور</h1>
            </div>
            <div class="content">
              <p class="message">
                ${name ? `مرحباً ${name},` : 'مرحباً،'}<br><br>
                لقد طلبت إعادة تعيين كلمة المرور لحسابك في Smart Card. استخدم الرمز التالي لإعادة تعيين كلمة المرور:
              </p>
              
              <div class="otp-box">
                <div style="font-size: 18px; margin-bottom: 10px;">رمز إعادة التعيين</div>
                <div class="otp-code">${otp}</div>
                <div style="font-size: 14px; opacity: 0.9;">صالح لمدة 10 دقائق</div>
              </div>
              
              <div class="warning">
                ⚠️ <strong>تنبيه أمني:</strong> إذا لم تطلب إعادة تعيين كلمة المرور، يرجى تجاهل هذه الرسالة. لا تشارك هذا الرمز مع أي شخص.
              </div>
              
              <p class="message">
                بعد إدخال الرمز، يمكنك اختيار كلمة مرور جديدة لحسابك.
              </p>
            </div>
            <div class="footer">
              <p>© 2024 Smart Card. جميع الحقوق محفوظة.</p>
              <p>هذه رسالة تلقائية، يرجى عدم الرد عليها.</p>
            </div>
          </div>
        </body>
        </html>
      `,
    };

    await sgMail.send(msg);
    console.log(`✅ Password reset email sent successfully to ${email}`);
    return { success: true };
  } catch (error) {
    console.error('❌ Error sending password reset email:', error);
    console.error('❌ Error details:', JSON.stringify(error.response?.body || error, null, 2));
    // Fallback to console
    console.log(`⚠️ Password reset OTP for ${email}: ${otp} (Email failed, check console)`);
    return { success: false, message: error.message || 'Failed to send email' };
  }
};

module.exports = {
  sendOTPEmail,
  sendWelcomeEmail,
  sendPasswordResetEmail
};
