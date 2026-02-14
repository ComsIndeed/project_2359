import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:project_2359/core/widgets/special_navigation_bar.dart';

import 'package:project_2359/core/widgets/tap_to_slide_up.dart';
import 'package:project_2359/features/home_page/home_page_content.dart';
import 'package:project_2359/features/materials_page/generate_materials_page.dart';
import 'package:project_2359/features/sources_page/sources_page.dart';
import 'package:project_2359/features/study_page/study_page_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavBarTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Removed Scaffolds bottomNavigationBar to use Stack for overlay effect
      body: SafeArea(
        bottom: false, // Allow content to go behind the custom nav bar area
        child: Stack(
          children: [
            // Main Content Layer with PageView for swipe and slide animations
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const [HomePageContent(), StudyPageContent()],
            ),

            // Navigation Bar Overlay Layer
            Align(
              alignment: Alignment.bottomCenter,
              child: SpecialNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onNavBarTap,
                items: [
                  const SpecialNavigationItem(
                    icon: FontAwesomeIcons.tableCellsLarge,
                    label: "Home",
                  ),
                  SpecialNavigationItem(
                    icon: FontAwesomeIcons.graduationCap,
                    label: "Study",
                    pageActions: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TapToSlideUp(
                          page: SourcesPage(),
                          builder: (pushPage) {
                            return TextButton.icon(
                              onPressed: pushPage,
                              icon: const FaIcon(
                                FontAwesomeIcons.layerGroup,
                                size: 16,
                              ),
                              label: const Text("Sources"),
                            );
                          },
                        ),
                        VerticalDivider(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.12),
                          width: 8,
                          indent: 8,
                          endIndent: 8,
                        ),
                        TapToSlideUp(
                          page: GenerateMaterialsPage(),
                          builder: (pushPage) {
                            return TextButton.icon(
                              onPressed: pushPage,
                              label: const Text("Generate Materials"),
                            );
                          },
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
