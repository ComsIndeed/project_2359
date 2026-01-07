import 'package:flutter/material.dart';
import 'package:project_2359_flutter/features/home/homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      routes: {'/': (context) => const Homepage()},
    );
  }
}
