#!/bin/bash

# سكريبت لتحميل خط Cairo من Google Fonts
# Script to download Cairo font from Google Fonts

echo "📥 تحميل خط Cairo من Google Fonts..."

# إنشاء مجلد الخطوط إذا لم يكن موجوداً
mkdir -p "assets/fonts"

# رابط تحميل Cairo من Google Fonts
CAIRO_URL="https://github.com/google/fonts/raw/main/ofl/cairo/Cairo%5Bslnt%2Cwght%5D.ttf"

echo "⏳ جاري التحميل..."
curl -L -o "assets/fonts/Cairo-Regular.ttf" "$CAIRO_URL" 2>/dev/null

if [ -f "assets/fonts/Cairo-Regular.ttf" ]; then
    echo "✅ تم تحميل الخط بنجاح!"
    echo "📁 الموقع: assets/fonts/Cairo-Regular.ttf"
    echo ""
    echo "⚠️  ملاحظة: هذا الخط متغير (variable font)"
    echo "   قد تحتاج لتحميل نسخ منفصلة من:"
    echo "   https://fonts.google.com/specimen/Cairo"
else
    echo "❌ فشل التحميل"
    echo "   يرجى تحميل الخط يدوياً من:"
    echo "   https://fonts.google.com/specimen/Cairo"
fi

