import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Generic "coming soon" destination used while forward screens are unbuilt.
/// Reused by tiles/nav so we don't hand-roll a placeholder per screen.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              '$title\ncoming soon',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
