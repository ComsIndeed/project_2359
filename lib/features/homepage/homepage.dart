import 'package:flutter/material.dart';

import 'package:project_2359/core/widgets/special_navigation_bar.dart';
import 'package:project_2359/features/homepage/home_page_content.dart';
import 'package:project_2359/features/study_page/study_page_content.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Removed Scaffolds bottomNavigationBar to use Stack for overlay effect
      body: SafeArea(
        bottom: false, // Allow content to go behind the custom nav bar area
        child: Stack(
          children: [
            // Main Content Layer
            IndexedStack(
              index: _selectedIndex,
              children: const [HomePageContent(), StudyPageContent()],
            ),

            // Navigation Bar Overlay Layer
            Align(
              alignment: Alignment.bottomCenter,
              child: SpecialNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                items: [
                  const SpecialNavigationItem(
                    icon: Icons.grid_view_rounded,
                    label: "Home",
                  ),
                  SpecialNavigationItem(
                    icon: Icons.school_rounded,
                    label: "Study",
                    pageActions: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            print("TEST"); // TODO: Connect to actual logic
                          },
                          child: const Text("Sources"),
                        ),
                        const VerticalDivider(color: Colors.white, width: 10),
                        TextButton(
                          onPressed: () {
                            // TODO: Connect to actual logic
                          },
                          child: const Text("Settings"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
