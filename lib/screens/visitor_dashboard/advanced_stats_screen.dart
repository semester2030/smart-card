import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/visitor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/common/animated_card.dart';
import 'package:fl_chart/fl_chart.dart';

/// Advanced Stats Screen for Visitor
/// شاشة الإحصائيات المتقدمة للزائر
class AdvancedStatsScreen extends StatelessWidget {
  const AdvancedStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visitorProvider = Provider.of<VisitorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final contacts = visitorProvider.contacts;
    final notes = visitorProvider.notes;
    final followUps = visitorProvider.followUps;

    // Calculate advanced stats
    final contactsByCategory = _calculateContactsByCategory(contacts);
    final contactsByDate = _calculateContactsByDate(contacts);
    final notesByContact = _calculateNotesByContact(notes);
    final followUpsByStatus = _calculateFollowUpsByStatus(followUps);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات المتقدمة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AnimatedCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      authProvider.currentUser?.name.isNotEmpty == true
                          ? authProvider.currentUser!.name[0].toUpperCase()
                          : 'V',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.currentUser?.name ?? 'زائر',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authProvider.currentUser?.expoId ?? 'SmartCard#1200',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Contacts by Category Chart
            AnimatedCard(
              delay: const Duration(milliseconds: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جهات الاتصال حسب الفئة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: contactsByCategory.entries.map((entry) {
                          final colors = [
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.purple,
                            Colors.red,
                          ];
                          final index = contactsByCategory.keys.toList().indexOf(entry.key);
                          return PieChartSectionData(
                            value: entry.value.toDouble(),
                            title: '${entry.value}',
                            color: colors[index % colors.length],
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...contactsByCategory.entries.map((entry) {
                    final colors = [
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                      Colors.red,
                    ];
                    final index = contactsByCategory.keys.toList().indexOf(entry.key);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(entry.key),
                          ),
                          Text(
                            '${entry.value}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Contacts Over Time Chart
            AnimatedCard(
              delay: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جهات الاتصال مع الوقت',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: contactsByDate.entries.map((entry) {
                              final index = contactsByDate.keys.toList().indexOf(entry.key);
                              return FlSpot(index.toDouble(), entry.value.toDouble());
                            }).toList(),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Notes Statistics
            AnimatedCard(
              delay: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات الملاحظات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'إجمالي الملاحظات',
                          '${notes.length}',
                          Icons.note,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'جهات اتصال مع ملاحظات',
                          '${notesByContact.length}',
                          Icons.contacts,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Follow-ups Statistics
            AnimatedCard(
              delay: const Duration(milliseconds: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات المتابعات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ...followUpsByStatus.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            entry.key == 'completed' ? Icons.check_circle : Icons.schedule,
                            color: entry.key == 'completed' ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.key == 'completed' ? 'مكتملة' : 'قيد الانتظار',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _calculateContactsByCategory(List contacts) {
    final map = <String, int>{};
    for (final contact in contacts) {
      final category = contact.category ?? 'غير محدد';
      map[category] = (map[category] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> _calculateContactsByDate(List<dynamic> contacts) {
    final map = <String, int>{};
    for (final contact in contacts) {
      final date = DateFormatter.formatDate(contact.scannedAt);
      map[date] = (map[date] ?? 0) + 1;
    }
    return map;
  }

  Set<String> _calculateNotesByContact(List<dynamic> notes) {
    return notes.map<String>((note) => note.contactId as String).toSet();
  }

  Map<String, int> _calculateFollowUpsByStatus(List<dynamic> followUps) {
    final map = <String, int>{'completed': 0, 'pending': 0};
    for (final followUp in followUps) {
      if (followUp.isCompleted) {
        map['completed'] = (map['completed'] ?? 0) + 1;
      } else {
        map['pending'] = (map['pending'] ?? 0) + 1;
      }
    }
    return map;
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

