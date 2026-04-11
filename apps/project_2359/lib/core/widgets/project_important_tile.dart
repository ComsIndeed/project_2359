import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class ProjectImportantTile extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ProjectImportantTile({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: AppTheme.important,
        shape: AppTheme.cardShape,
      ),
      child: child,
    );
  }
}
