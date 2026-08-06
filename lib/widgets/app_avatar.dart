import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Circular avatar that shows an asset image, falling back to an icon on a
/// soft-green circle when no asset is given or the image fails to load.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.asset,
    required this.fallbackIcon,
    this.size = 56,
    this.iconSize,
  });

  final String? asset;
  final IconData fallbackIcon;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.softGreen,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        color: AppColors.primary,
        size: iconSize ?? size * 0.54,
      ),
    );

    if (asset == null) return placeholder;

    return ClipOval(
      child: Image.asset(
        asset!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}
