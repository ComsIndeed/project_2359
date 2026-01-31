import 'package:flutter/material.dart';

import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';

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
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(context),
            const Center(
              child: Text(
                "Study Page",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          const SpecialSearchBar(),
          const SizedBox(height: 24),
          SectionHeader(title: "Recent Activity"),
          ActivityListItem(
            icon: Icons.quiz,
            title: "Cell Biology Quiz",
            subtitle: "Score: 8/10 • 2h ago",
            iconColor: Colors.blue,
            onTap: () {},
          ),
          ActivityListItem(
            icon: Icons.description,
            title: "Lecture Notes: Week 3",
            subtitle: "Added to Library • 5h ago",
            iconColor: Colors.pink,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 260, // Compact width
            height: 60, // Smaller height
            padding: const EdgeInsets.all(6),
            decoration: ShapeDecoration(
              color: AppTheme.surface.withValues(alpha: 0.95),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Sliding Pill Background
                AnimatedAlign(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(_selectedIndex == 0 ? -1 : 1, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1,
                    child: Container(
                      decoration: ShapeDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                // Navigation Items
                Row(
                  children: [
                    Expanded(
                      child: _buildNavItem(0, Icons.grid_view_rounded, "Home"),
                    ),
                    Expanded(
                      child: _buildNavItem(1, Icons.school_rounded, "Study"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final navShape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(18),
    );

    return RepaintBoundary(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        customBorder: navShape,
        splashColor: AppTheme.primary.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time to focus, Alex",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text("Good Evening", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?u=a042581f4e29026704d',
          ),
        ),
      ],
    );
  }
}
