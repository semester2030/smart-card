import 'package:flutter/material.dart';
import '../common/svg_icon.dart';

/// Info Card
/// بطاقة معلومات
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? svgIconPath;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.svgIconPath,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  }) : assert(icon != null || svgIconPath != null, 'Either icon or svgIconPath must be provided');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
          child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor ??
                      (iconColor ?? Theme.of(context).colorScheme.primary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: svgIconPath != null
                      ? SvgIcon(
                          assetPath: svgIconPath!,
                          width: 24,
                          height: 24,
                          color: iconColor ?? Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          icon,
                          color: iconColor ?? Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[400],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

