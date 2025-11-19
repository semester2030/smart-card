import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/visitor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/cards/contact_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/buttons/icon_button.dart' as custom;
import '../../widgets/cards/info_card.dart';
import '../../widgets/common/animated_card.dart';
import '../../screens/shared/contact_card_screen.dart';

/// Visitor Home Screen
/// لوحة تحكم الزائر الرئيسية
class VisitorHomeScreen extends StatefulWidget {
  const VisitorHomeScreen({super.key});

  @override
  State<VisitorHomeScreen> createState() => _VisitorHomeScreenState();
}

class _VisitorHomeScreenState extends State<VisitorHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisitorProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final visitorProvider = Provider.of<VisitorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الزائر'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                authProvider.currentUser?.expoId ?? 'SmartCard#1200',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Profile Icon Button
          custom.CustomIconButton(
            icon: Icons.person,
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.visitorProfile);
            },
            tooltip: 'الملف الشخصي',
          ),
          custom.CustomIconButton(
            icon: Icons.home,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Routes.home);
            },
            tooltip: 'الصفحة الرئيسية',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => visitorProvider.loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards with Animation
              Row(
                children: [
                  Expanded(
                    child: AnimatedCard(
                      delay: const Duration(milliseconds: 100),
                      child: InfoCard(
                        title: '${visitorProvider.contactsCount}',
                        subtitle: 'جهات اتصال',
                        svgIconPath: 'assets/icons/profile.svg',
                        iconColor: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedCard(
                      delay: const Duration(milliseconds: 200),
                      child: InfoCard(
                        title: '${visitorProvider.notesCount}',
                        subtitle: 'ملاحظات',
                        svgIconPath: 'assets/icons/voice.svg',
                        iconColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AnimatedCard(
                      delay: const Duration(milliseconds: 300),
                      child: InfoCard(
                        title: '${visitorProvider.followUpsCount}',
                        subtitle: 'متابعات',
                        svgIconPath: 'assets/icons/calender.svg',
                        iconColor: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedCard(
                      delay: const Duration(milliseconds: 400),
                      child: InfoCard(
                        title: '${visitorProvider.upcomingFollowUpsCount}',
                        subtitle: 'قادمة',
                        svgIconPath: 'assets/icons/calender.svg',
                        iconColor: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedCard(
                delay: const Duration(milliseconds: 500),
                child: InfoCard(
                  title: 'إحصائيات',
                  subtitle: 'متقدمة',
                  svgIconPath: 'assets/icons/search.svg',
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.visitorAdvancedStats);
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Quick Actions
              const Text(
                'إجراءات سريعة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'مسح QR',
                      svgIconPath: 'assets/icons/bottom_camera.svg',
                      iconColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.scan);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      title: 'جهات الاتصال',
                      svgIconPath: 'assets/icons/profile.svg',
                      iconColor: Colors.blue,
                      onTap: () {
                        // TODO: Navigate to contacts list
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Recent Contacts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'جهات الاتصال الأخيرة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          // Refresh data from API
                          final visitorProvider = Provider.of<VisitorProvider>(context, listen: false);
                          await visitorProvider.loadData();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم تحديث البيانات'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Text('تحديث'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to all contacts
                        },
                        child: const Text('عرض الكل'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Contacts List
              if (visitorProvider.isLoading)
                const LoadingIndicator()
              else if (visitorProvider.error != null)
                ErrorState(
                  message: visitorProvider.error!,
                  onRetry: () => visitorProvider.loadContacts(),
                )
              else if (visitorProvider.contacts.isEmpty)
                const EmptyState(
                  icon: Icons.contacts,
                  title: 'لا توجد جهات اتصال',
                  message: 'ابدأ بمسح QR code لإضافة جهات اتصال',
                )
              else
                ...visitorProvider.contacts.take(5).map(
                      (contact) => ContactCard(
                        contact: contact,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ContactCardScreen(contact: contact),
                            ),
                          );
                        },
                        onDelete: () {
                          visitorProvider.deleteContact(contact.id);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.scan);
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('مسح QR'),
      ),
    );
  }
}

