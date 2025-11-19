import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exhibitor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/cards/lead_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/buttons/icon_button.dart' as custom;
import '../../widgets/cards/info_card.dart';
import '../../widgets/common/animated_card.dart';

/// Exhibitor Home Screen
/// لوحة تحكم العارض الرئيسية
class ExhibitorHomeScreen extends StatefulWidget {
  const ExhibitorHomeScreen({super.key});

  @override
  State<ExhibitorHomeScreen> createState() => _ExhibitorHomeScreenState();
}

class _ExhibitorHomeScreenState extends State<ExhibitorHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExhibitorProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم العارض'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                authProvider.currentUser?.expoId ?? 'SmartCard#2048',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
        onRefresh: () => exhibitorProvider.loadData(),
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
                        title: '${exhibitorProvider.leadsCount}',
                        subtitle: 'Leads',
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
                        title: '${exhibitorProvider.highPriorityLeadsCount}',
                        subtitle: 'عالي الجودة',
                        icon: Icons.star,
                        iconColor: Colors.orange,
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
                        title: '${exhibitorProvider.newLeadsCount}',
                        subtitle: 'جديد',
                        icon: Icons.new_releases,
                        iconColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedCard(
                      delay: const Duration(milliseconds: 400),
                      child: InfoCard(
                        title: '${exhibitorProvider.pendingRequestsCount}',
                        subtitle: 'طلبات',
                        svgIconPath: 'assets/icons/notification.svg',
                        iconColor: Colors.red,
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
                    Navigator.of(context).pushNamed(Routes.exhibitorAdvancedStats);
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
                      title: 'QR Code',
                      svgIconPath: 'assets/icons/bottom_camera.svg',
                      iconColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.qrGenerator);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      title: 'الملف الشخصي',
                      svgIconPath: 'assets/icons/profile.svg',
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.exhibitorProfile);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Recent Leads
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leads الأخيرة',
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
                          final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
                          await exhibitorProvider.loadLeads(forceRefresh: true);
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
                          // TODO: Navigate to all leads
                        },
                        child: const Text('عرض الكل'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Leads List
              if (exhibitorProvider.isLoading)
                const LoadingIndicator()
              else if (exhibitorProvider.error != null)
                ErrorState(
                  message: exhibitorProvider.error!,
                  onRetry: () => exhibitorProvider.loadLeads(),
                )
              else if (exhibitorProvider.leads.isEmpty)
                const EmptyState(
                  icon: Icons.people,
                  title: 'لا توجد Leads',
                  message: 'ابدأ بجمع Leads من الزوار',
                )
              else
                ...exhibitorProvider.leads.take(5).map(
                      (lead) => LeadCard(
                        lead: lead,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.leadDetail,
                            arguments: {
                              'leadId': lead.id,
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

