import 'package:flutter/material.dart';
import 'package:project_2359/app_config.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: "Sources",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: "Profile",
          ),
        ],
      ),
      body: Column(children: [Text(AppConfig.appName)]),
    );
  }
}
