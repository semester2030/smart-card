import 'package:flutter/material.dart';
import '../../utils/date_formatter.dart';

/// Date Picker
/// منتقي التاريخ
class CustomDatePicker extends StatelessWidget {
  final String? label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime)? onDateSelected;
  final String? Function(DateTime?)? validator;

  const CustomDatePicker({
    super.key,
    this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      locale: const Locale('ar', 'SA'),
    );

    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          initialDate != null
              ? DateFormatter.formatDateArabic(initialDate!)
              : 'اختر التاريخ',
          style: TextStyle(
            fontSize: 16,
            color: initialDate != null ? null : Colors.grey[500],
          ),
        ),
      ),
    );
  }
}

