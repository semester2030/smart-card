import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG Icon Widget
/// Widget لاستخدام أيقونات SVG
class SvgIcon extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const SvgIcon({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: fit,
      placeholderBuilder: (context) => Container(
        width: width ?? 24,
        height: height ?? 24,
        color: Colors.grey[300],
      ),
    );
  }
}

/// SVG Icon Button
/// زر بأيقونة SVG
class SvgIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;

  const SvgIconButton({
    super.key,
    required this.assetPath,
    this.onPressed,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: SvgIcon(
          assetPath: assetPath,
          width: size * 0.5,
          height: size * 0.5,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
        ),
        padding: EdgeInsets.zero,
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

