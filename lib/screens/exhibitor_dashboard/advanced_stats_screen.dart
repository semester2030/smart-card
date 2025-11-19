import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exhibitor_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/common/animated_card.dart';
import 'package:fl_chart/fl_chart.dart';

/// Advanced Stats Screen for Exhibitor
/// شاشة الإحصائيات المتقدمة للعارض
class ExhibitorAdvancedStatsScreen extends StatelessWidget {
  const ExhibitorAdvancedStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exhibitorProvider = Provider.of<ExhibitorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final leads = exhibitorProvider.leads;
    final requests = exhibitorProvider.requests;

    // Calculate advanced stats
    final leadsByStatus = _calculateLeadsByStatus(leads);
    final leadsByScore = _calculateLeadsByScore(leads);
    final leadsByDate = _calculateLeadsByDate(leads);
    final conversionRate = _calculateConversionRate(leads);
    final avgScore = _calculateAverageScore(leads);

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
                          : 'E',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.currentUser?.companyName ?? 'عارض',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authProvider.currentUser?.expoId ?? 'SmartCard#2048',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Key Metrics
            AnimatedCard(
              delay: const Duration(milliseconds: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المؤشرات الرئيسية',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          'معدل التحويل',
                          '${conversionRate.toStringAsFixed(1)}%',
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          'متوسط AI Score',
                          avgScore.toStringAsFixed(0),
                          Icons.star,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Leads by Status Chart
            AnimatedCard(
              delay: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leads حسب الحالة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: leadsByStatus.entries.map((entry) {
                          final colors = {
                            'new': Colors.blue,
                            'contacted': Colors.orange,
                            'interested': Colors.green,
                            'follow-up': Colors.purple,
                            'not-interested': Colors.red,
                          };
                          return PieChartSectionData(
                            value: entry.value.toDouble(),
                            title: '${entry.value}',
                            color: colors[entry.key] ?? Colors.grey,
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
                  ...leadsByStatus.entries.map((entry) {
                    final statusNames = {
                      'new': 'جديد',
                      'contacted': 'تم التواصل',
                      'interested': 'مهتم',
                      'follow-up': 'متابعة',
                      'not-interested': 'غير مهتم',
                    };
                    final colors = {
                      'new': Colors.blue,
                      'contacted': Colors.orange,
                      'interested': Colors.green,
                      'follow-up': Colors.purple,
                      'not-interested': Colors.red,
                    };
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colors[entry.key] ?? Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(statusNames[entry.key] ?? entry.key),
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
            // Leads by Score Chart
            AnimatedCard(
              delay: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leads حسب AI Score',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: leadsByScore.values.reduce((a, b) => a > b ? a : b).toDouble() + 5,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final labels = ['عالي', 'متوسط', 'منخفض'];
                                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                                  return Text(labels[value.toInt()]);
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: leadsByScore.entries.map((entry) {
                          final colors = {
                            'high': Colors.green,
                            'medium': Colors.orange,
                            'low': Colors.red,
                          };
                          final index = leadsByScore.keys.toList().indexOf(entry.key);
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.toDouble(),
                                color: colors[entry.key] ?? Colors.grey,
                                width: 40,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Leads Over Time
            AnimatedCard(
              delay: const Duration(milliseconds: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leads مع الوقت',
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
                            spots: leadsByDate.entries.map((entry) {
                              final index = leadsByDate.keys.toList().indexOf(entry.key);
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
            // Requests Statistics
            AnimatedCard(
              delay: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات طلبات التواصل',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'إجمالي الطلبات',
                          '${requests.length}',
                          Icons.mail,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'قيد الانتظار',
                          '${requests.where((r) => r.isPending).length}',
                          Icons.schedule,
                          Colors.orange,
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
    );
  }

  Map<String, int> _calculateLeadsByStatus(List<dynamic> leads) {
    final map = <String, int>{};
    for (final lead in leads) {
      final status = lead.status;
      map[status] = (map[status] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> _calculateLeadsByScore(List<dynamic> leads) {
    final map = <String, int>{'high': 0, 'medium': 0, 'low': 0};
    for (final lead in leads) {
      if (lead.aiScore >= 70) {
        map['high'] = (map['high'] ?? 0) + 1;
      } else if (lead.aiScore >= 50) {
        map['medium'] = (map['medium'] ?? 0) + 1;
      } else {
        map['low'] = (map['low'] ?? 0) + 1;
      }
    }
    return map;
  }

  Map<String, int> _calculateLeadsByDate(List<dynamic> leads) {
    final map = <String, int>{};
    for (final lead in leads) {
      final date = DateFormatter.formatDate(lead.scannedAt);
      map[date] = (map[date] ?? 0) + 1;
    }
    return map;
  }

  double _calculateConversionRate(List<dynamic> leads) {
    if (leads.isEmpty) return 0.0;
    final interested = leads.where((l) => l.status == 'interested' || l.status == 'follow-up').length;
    return (interested / leads.length) * 100;
  }

  double _calculateAverageScore(List<dynamic> leads) {
    if (leads.isEmpty) return 0.0;
    final sum = leads.fold(0.0, (sum, lead) => sum + lead.aiScore);
    return sum / leads.length;
  }

  Widget _buildMetricCard(
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

