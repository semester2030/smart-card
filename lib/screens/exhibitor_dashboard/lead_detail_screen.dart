import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exhibitor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_formatter.dart';
import '../../utils/helpers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/forms/note_input_with_voice.dart';
import '../../widgets/common/animated_card.dart';
import '../../models/lead_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// Lead Detail Screen for Exhibitor
/// شاشة تفاصيل Lead الكاملة (مثل الموقع)
class LeadDetailScreen extends StatefulWidget {
  final String leadId;

  const LeadDetailScreen({
    super.key,
    required this.leadId,
  });

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedFollowUpPeriod;
  DateTime? _scheduledFollowUpDate;

  @override
  void initState() {
    super.initState();
    _loadLeadData();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadLeadData() {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    final lead = exhibitorProvider.getLeadById(widget.leadId);
    
    if (lead != null) {
      _noteController.text = lead.notes ?? '';
      _scheduledFollowUpDate = lead.followUpDate;
    }
  }

  Future<void> _updateLeadStatus(String status) async {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    final success = await exhibitorProvider.updateLeadStatus(widget.leadId, status);
    
    if (!mounted) return;
    
    if (success) {
      Helpers.showSuccessSnackBar(context, 'تم تحديث الحالة بنجاح!');
      setState(() {}); // Refresh UI
    } else {
      Helpers.showErrorSnackBar(context, exhibitorProvider.error ?? 'فشل تحديث الحالة');
    }
  }

  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) {
      Helpers.showErrorSnackBar(context, 'يرجى إدخال نص الملاحظة');
      return;
    }

    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    final lead = exhibitorProvider.getLeadById(widget.leadId);
    
    if (lead != null) {
      final updatedLead = lead.copyWith(
        notes: _noteController.text.trim(),
        updatedAt: DateTime.now(),
      );
      
      final success = await exhibitorProvider.updateLead(updatedLead);

      if (!mounted) return;

      if (success) {
        Helpers.showSuccessSnackBar(context, 'تم حفظ الملاحظة بنجاح!');
        setState(() {}); // Refresh UI
      } else {
        Helpers.showErrorSnackBar(
          context,
          exhibitorProvider.error ?? 'فشل حفظ الملاحظة',
        );
      }
    }
  }

  void _selectFollowUpPeriod(String period) {
    setState(() {
      _selectedFollowUpPeriod = period;
      
      final now = DateTime.now();
      switch (period) {
        case '3days':
          _scheduledFollowUpDate = now.add(const Duration(days: 3));
          break;
        case '1week':
          _scheduledFollowUpDate = now.add(const Duration(days: 7));
          break;
        case '2weeks':
          _scheduledFollowUpDate = now.add(const Duration(days: 14));
          break;
        case '1month':
          _scheduledFollowUpDate = now.add(const Duration(days: 30));
          break;
      }
    });
    
    // Show feedback
    Helpers.showSuccessSnackBar(
      context,
      'تم اختيار: ${_getPeriodLabel(period)}',
    );
  }
  
  String _getPeriodLabel(String period) {
    switch (period) {
      case '3days':
        return '3 أيام';
      case '1week':
        return 'أسبوع';
      case '2weeks':
        return 'أسبوعان';
      case '1month':
        return 'شهر';
      default:
        return period;
    }
  }

  Future<void> _saveFollowUp() async {
    if (_scheduledFollowUpDate == null) {
      Helpers.showErrorSnackBar(context, 'يرجى اختيار فترة المتابعة');
      return;
    }

    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    final lead = exhibitorProvider.getLeadById(widget.leadId);
    
    if (lead != null) {
      final updatedLead = lead.copyWith(
        followUpDate: _scheduledFollowUpDate,
        status: 'follow-up',
        updatedAt: DateTime.now(),
      );
      
      final success = await exhibitorProvider.updateLead(updatedLead);

      if (!mounted) return;

      if (success) {
        Helpers.showSuccessSnackBar(context, 'تم جدولة المتابعة بنجاح!');
        setState(() {}); // Refresh UI
      } else {
        Helpers.showErrorSnackBar(
          context,
          exhibitorProvider.error ?? 'فشل جدولة المتابعة',
        );
      }
    }
  }

  Future<void> _sendWhatsAppMessage() async {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lead = exhibitorProvider.getLeadById(widget.leadId);
    
    if (lead == null) return;
    
    // Get phone number
    String phone = lead.visitorPhone?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
    
    // If no phone, try to get from SmartCardID (for demo purposes)
    if (phone.isEmpty) {
      // Show dialog to enter phone number
      final phoneController = TextEditingController();
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('إدخال رقم الهاتف'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف',
              hintText: 'مثال: 966501234567',
              prefixText: '+',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (phoneController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(phoneController.text.trim());
                }
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      );
      
      if (result == null || result.isEmpty) {
        if (mounted) {
          Helpers.showErrorSnackBar(context, 'لم يتم إدخال رقم الهاتف');
        }
        return;
      }
      
      phone = result.replaceAll(RegExp(r'[^\d]'), '');
    }
    
    if (phone.isEmpty) {
      if (mounted) {
        Helpers.showErrorSnackBar(context, 'رقم الهاتف غير متوفر');
      }
      return;
    }
    
    // Get exhibitor info
    final exhibitorName = authProvider.currentUser?.name ?? 'العارض';
    final exhibitorExpoId = authProvider.currentUser?.expoId ?? '';
    
    // Create attractive WhatsApp message
    final message = _buildWhatsAppMessage(lead, exhibitorName, exhibitorExpoId);
    
    // Try multiple WhatsApp URL formats
    await _launchWhatsApp(phone, message);
  }
  
  Future<void> _launchWhatsApp(String phone, String message) async {
    // Remove leading zeros and ensure country code format
    String cleanPhone = phone;
    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    if (!cleanPhone.startsWith('966')) {
      cleanPhone = '966$cleanPhone';
    }
    
    // Try multiple URL formats
    final urls = [
      'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}',
      'whatsapp://send?phone=$cleanPhone&text=${Uri.encodeComponent(message)}',
      'https://api.whatsapp.com/send?phone=$cleanPhone&text=${Uri.encodeComponent(message)}',
    ];
    
    bool launched = false;
    
    for (final urlString in urls) {
      try {
        final uri = Uri.parse(urlString);
        
        // Check if URL can be launched
        if (await canLaunchUrl(uri)) {
          // Try to launch
          final result = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          
          if (result) {
            launched = true;
            if (mounted) {
              Helpers.showSuccessSnackBar(context, 'تم فتح WhatsApp بنجاح!');
            }
            break;
          }
        }
      } catch (e) {
        // Continue to next URL format
        continue;
      }
    }
    
    if (!launched) {
      if (mounted) {
        // Show dialog with manual option
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('لا يمكن فتح WhatsApp'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('يرجى التأكد من:'),
                const SizedBox(height: 8),
                const Text('• تثبيت تطبيق WhatsApp'),
                const Text('• وجود اتصال بالإنترنت'),
                const SizedBox(height: 16),
                Text(
                  'رقم الهاتف: +$cleanPhone',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      }
    }
  }
  
  String _buildWhatsAppMessage(LeadModel lead, String exhibitorName, String exhibitorExpoId) {
    // Build an attractive, professional message
    final buffer = StringBuffer();
    
    // Greeting with emoji
    buffer.writeln('👋 السلام عليكم ورحمة الله وبركاته');
    buffer.writeln('');
    
    // Personal greeting
    buffer.writeln('${lead.visitorName} عزيزي/عزيزتي،');
    buffer.writeln('');
    
    // Thank you message
    buffer.writeln('✨ شكراً جزيلاً لزيارتكم جناحنا في المعرض.');
    buffer.writeln('');
    
    // Follow-up message
    buffer.writeln('💼 نود متابعة الحديث معكم حول فرص التعاون والشراكة المثمرة.');
    buffer.writeln('');
    
    // AI Score mention (if high)
    if (lead.isHighPriority) {
      buffer.writeln('⭐ لقد لاحظنا اهتمامكم الكبير بخدماتنا، ونحن متحمسون للتعاون معكم.');
      buffer.writeln('');
    }
    
    // Call to action
    buffer.writeln('📞 هل يمكننا تحديد موعد مكالمة أو لقاء لمناقشة التفاصيل؟');
    buffer.writeln('');
    
    // Signature
    buffer.writeln('مع أطيب التحيات،');
    buffer.writeln('$exhibitorName');
    if (exhibitorExpoId.isNotEmpty) {
      buffer.writeln(exhibitorExpoId);
    }
    buffer.writeln('');
    buffer.writeln('📱 Smart Card App');
    
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context);
    final lead = exhibitorProvider.getLeadById(widget.leadId);

    if (lead == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل Lead'),
        ),
        body: const Center(
          child: Text('Lead غير موجود'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات الزائر'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Avatar
                AnimatedCard(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          lead.visitorName.isNotEmpty
                              ? lead.visitorName[0].toUpperCase()
                              : 'L',
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lead.visitorName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lead.visitorExpoId,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Visitor Information Section
                AnimatedCard(
                  delay: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'معلومات الزائر',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(context, 'الاسم', lead.visitorName),
                      _buildInfoRow(context, 'SmartCardID', lead.visitorExpoId),
                      if (lead.visitorEmail != null)
                        _buildInfoRow(context, 'البريد الإلكتروني', lead.visitorEmail!),
                      if (lead.visitorPhone != null)
                        _buildInfoRow(context, 'الهاتف', lead.visitorPhone!),
                      _buildInfoRow(
                        context,
                        'تاريخ المسح',
                        DateFormatter.formatDateTime(lead.scannedAt),
                      ),
                      _buildInfoRow(
                        context,
                        'AI Score',
                        '${lead.aiScore}/100',
                        valueWidget: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: (lead.isHighPriority
                                    ? Colors.green
                                    : lead.isMediumPriority
                                        ? Colors.orange
                                        : Colors.red)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: lead.isHighPriority
                                    ? Colors.green
                                    : lead.isMediumPriority
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${lead.aiScore}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: lead.isHighPriority
                                      ? Colors.green
                                      : lead.isMediumPriority
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Status Dropdown
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الحالة',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: lead.status,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'new',
                                      child: Text('جديد'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'contacted',
                                      child: Text('تم التواصل'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'interested',
                                      child: Text('مهتم'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'follow-up',
                                      child: Text('متابعة'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'not-interested',
                                      child: Text('غير مهتم'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      _updateLeadStatus(value);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Notes Section
                AnimatedCard(
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ملاحظاتي',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      NoteInputWithVoice(
                        controller: _noteController,
                        hint: 'اكتب ملاحظة عن هذا الزائر...',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'حفظ الملاحظة',
                        icon: Icons.save,
                        isLoading: exhibitorProvider.isLoading,
                        onPressed: _saveNote,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Follow-up Section
                AnimatedCard(
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'جدولة متابعة',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Follow-up Options
                      Row(
                        children: [
                          Expanded(
                            child: _buildFollowUpOption(
                              context,
                              '3 أيام',
                              '3days',
                              Icons.today,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFollowUpOption(
                              context,
                              'أسبوع',
                              '1week',
                              Icons.date_range,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFollowUpOption(
                              context,
                              'أسبوعان',
                              '2weeks',
                              Icons.calendar_month,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFollowUpOption(
                              context,
                              'شهر',
                              '1month',
                              Icons.event,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'حفظ المتابعة',
                        icon: Icons.add_circle,
                        isLoading: exhibitorProvider.isLoading,
                        onPressed: _saveFollowUp,
                        width: double.infinity,
                      ),
                      if (_scheduledFollowUpDate != null || lead.followUpDate != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.event_available,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'متابعة مجدولة: ${DateFormatter.formatDate(_scheduledFollowUpDate ?? (lead.followUpDate ?? DateTime.now()))}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Actions
                AnimatedCard(
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: SecondaryButton(
                              text: 'إغلاق',
                              onPressed: () => Navigator.of(context).pop(),
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: PrimaryButton(
                              text: 'إرسال',
                              icon: Icons.message,
                              backgroundColor: Colors.green,
                              onPressed: _sendWhatsAppMessage,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {Widget? valueWidget}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: valueWidget ??
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpOption(
    BuildContext context,
    String label,
    String period,
    IconData icon,
  ) {
    final isSelected = _selectedFollowUpPeriod == period;
    
    return InkWell(
      onTap: () => _selectFollowUpPeriod(period),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

