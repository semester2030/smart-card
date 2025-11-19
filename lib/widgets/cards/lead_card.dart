import 'package:flutter/material.dart';
import '../../models/lead_model.dart';
import '../../utils/date_formatter.dart';

/// Lead Card
/// بطاقة Lead
class LeadCard extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChange;

  const LeadCard({
    super.key,
    required this.lead,
    this.onTap,
    this.onStatusChange,
  });

  Color _getStatusColor(BuildContext context) {
    switch (lead.status) {
      case 'new':
        return Colors.blue;
      case 'contacted':
        return Colors.orange;
      case 'interested':
        return Colors.green;
      case 'follow-up':
        return Colors.purple;
      case 'converted':
        return Colors.teal;
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (lead.status) {
      case 'new':
        return 'جديد';
      case 'contacted':
        return 'تم التواصل';
      case 'interested':
        return 'مهتم';
      case 'follow-up':
        return 'متابعة';
      case 'converted':
        return 'محول';
      case 'lost':
        return 'مفقود';
      default:
        return lead.status;
    }
  }

  Color _getScoreColor() {
    if (lead.isHighPriority) return Colors.green;
    if (lead.isMediumPriority) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.visitorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lead.visitorExpoId,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(context).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getStatusColor(context)),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getScoreColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: _getScoreColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lead.aiScore}/100',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getScoreColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormatter.getRelativeTime(lead.scannedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

