import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:playground/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  pdfrxFlutterInitialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
