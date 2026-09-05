import 'package:flutter/material.dart';

/// شعار وأيقونة سِراج الرسمية بأبعاد وتأطير احترافي متناسق
class SirajAppLogo extends StatelessWidget {
  final double size;
  final double? borderRadius;
  final bool showBorder;
  final bool showShadow;
  final VoidCallback? onTap;

  const SirajAppLogo({
    super.key,
    this.size = 48,
    this.borderRadius,
    this.showBorder = true,
    this.showShadow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? (size * 0.22);

    Widget logoContent = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(radius),
        border: showBorder
            ? Border.all(
                color: const Color(0xFFDAA520).withValues(alpha: 0.6),
                width: size > 64 ? 2.0 : 1.2,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: size * 0.15,
                  offset: Offset(0, size * 0.06),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - (showBorder ? 1.0 : 0)),
        child: Image.asset(
          'assets/images/app_icon.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.menu_book_rounded,
              size: size * 0.5,
              color: const Color(0xFFDAA520),
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: logoContent,
      );
    }

    return logoContent;
  }
}
