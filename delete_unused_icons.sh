#!/bin/bash

# حذف الأيقونات غير الضرورية
# Delete unused icons

cd "assets/icons"

# قائمة الأيقونات للحذف
icons_to_delete=(
  "additional_details.svg"
  "apple.svg"
  "blutooth.svg"
  "bookings.svg"
  "briefcase.svg"
  "bus.svg"
  "car_signal.svg"
  "city.svg"
  "city_2.svg"
  "confirm_booking.svg"
  "daily_transport.svg"
  "district.svg"
  "driver.svg"
  "female_employee.svg"
  "frendos_map_unselected.svg"
  "gender.svg"
  "google.svg"
  "intrested.svg"
  "messenger_unselected.svg"
  "new_withdraw.svg"
  "pay.svg"
  "payment.svg"
  "report.svg"
  "sedan.svg"
  "service_type.svg"
  "small_bus.svg"
  "small_van.svg"
  "student_cap.svg"
  "teacher_bag.svg"
  "thrift_calculator.svg"
  "total_booking.svg"
  "total_earnings.svg"
  "upcoming_booking.svg"
  "vehicle_model.svg"
  "watch.svg"
  "withdraw.svg"
)

echo "🗑️  حذف الأيقونات غير الضرورية..."
deleted_count=0

for icon in "${icons_to_delete[@]}"; do
  if [ -f "$icon" ]; then
    rm "$icon"
    echo "✅ حذف: $icon"
    ((deleted_count++))
  else
    echo "⚠️  غير موجود: $icon"
  fi
done

echo ""
echo "✅ تم حذف $deleted_count أيقونة"
echo "📁 الأيقونات المتبقية: $(ls -1 *.svg 2>/dev/null | wc -l | tr -d ' ')"

