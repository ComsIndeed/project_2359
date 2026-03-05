import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:project_2359/core/widgets/special_navigation_bar.dart';

import 'package:project_2359/features/home_page/home_page_content.dart';
import 'package:project_2359/features/materials_page/generation_wizard_page.dart';
import 'package:project_2359/features/sources_page/sources_page.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
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
              scrollDirection: Axis.vertical,
              physics: const FastPageScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              onPageChanged: _onPageChanged,
              children: const [HomePageContent(), StudyPageContent()],
            ),

            // Navigation Bar Overlay Layer
            Align(
              alignment: Alignment.bottomCenter,
              child: SpecialNavigationBar(
                currentIndex: 0,
                onTap: (index) {
                  _onNavBarTap(_selectedIndex == 0 ? 1 : 0);
                },
                items: [
                  SpecialNavigationItem(
                    icon: _selectedIndex == 0
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronUp,
                    label: _selectedIndex == 0 ? "Library" : "Dashboard",
                    pageActions: _selectedIndex == 1
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SourcesPage(
                                        sourceService: context
                                            .read<SourcesPageBloc>()
                                            .sourceService,
                                      ),
                                    ),
                                  );
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.layerGroup,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1.5,
                                height: 16,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GenerateMaterialsWizardPage(),
                                    ),
                                  );
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.wandSparkles,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : null,
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

class FastPageScrollPhysics extends PageScrollPhysics {
  const FastPageScrollPhysics({super.parent});

  @override
  FastPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 20.0;

  @override
  double get minFlingDistance => 5.0;
}
