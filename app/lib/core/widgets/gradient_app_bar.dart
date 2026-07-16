import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.bottom,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: const SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          if (subtitle != null)
            Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + 16 + (bottom?.preferredSize.height ?? 0));
}
