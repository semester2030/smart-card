import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/contact_model.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../providers/visitor_provider.dart';
import '../../config/routes.dart';

/// Contact Card Screen
/// شاشة عرض تفاصيل جهة الاتصال
class ContactCardScreen extends StatelessWidget {
  final ContactModel contact;

  const ContactCardScreen({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل جهة الاتصال'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      contact.companyName ?? contact.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      contact.expoId,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Contact Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات الاتصال',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.person, 'الاسم', contact.name),
                    if (contact.category != null)
                      _buildInfoRow(Icons.category, 'الفئة', contact.category!),
                    if (contact.booth != null)
                      _buildInfoRow(Icons.location_on, 'الجناح', contact.booth!),
                    if (contact.phone != null)
                      _buildInfoRow(Icons.phone, 'الهاتف', contact.phone!),
                    if (contact.email != null)
                      _buildInfoRow(Icons.email, 'البريد', contact.email!),
                    if (contact.website != null)
                      _buildInfoRow(Icons.language, 'الموقع', contact.website!),
                    _buildInfoRow(
                      Icons.access_time,
                      'تاريخ المسح',
                      DateFormatter.formatDateTimeArabic(contact.scannedAt),
                    ),
                  ],
                ),
              ),
            ),
            // Description
            if (contact.description != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الوصف',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contact.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Brochure
            if (contact.brochure != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            'البروشور الرقمي',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        contact.brochure!.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (contact.brochure!.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          contact.brochure!.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                      if (contact.brochure!.features != null &&
                          contact.brochure!.features!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'المميزات:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...contact.brochure!.features!.map(
                          (feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (contact.brochure!.services != null &&
                          contact.brochure!.services!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: contact.brochure!.services!.map(
                            (service) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                service,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                      if (contact.brochure!.fileUrl != null) ...[
                        const SizedBox(height: 16),
                        PrimaryButton(
                          text: 'تحميل البروشور',
                          icon: Icons.download,
                          onPressed: () {
                            // TODO: Handle download
                          },
                          backgroundColor: Colors.white,
                          textColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Actions
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<VisitorProvider>(
                          builder: (context, visitorProvider, _) {
                            return PrimaryButton(
                              text: 'حفظ',
                              icon: Icons.save,
                              isLoading: visitorProvider.isLoading,
                              onPressed: () async {
                                final success = await visitorProvider.addContact(contact);
                                if (context.mounted) {
                                  if (success) {
                                    Navigator.of(context).pushReplacementNamed(
                                      Routes.visitorDashboard,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم حفظ جهة الاتصال بنجاح!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(visitorProvider.error ?? 'حدث خطأ'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SecondaryButton(
                          text: 'ملاحظة',
                          icon: Icons.note_add,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              Routes.addNote,
                              arguments: {
                                'contactId': contact.id,
                                'contactName': contact.companyName ?? contact.name,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    text: 'إغلاق',
                    onPressed: () => Navigator.of(context).pop(),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

