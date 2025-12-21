import 'package:flutter/material.dart';
import 'package:project_2359/core/theme/app_theme.dart';
import 'package:project_2359/core/widgets/homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.darkTheme, home: const Homepage());
  }
}
