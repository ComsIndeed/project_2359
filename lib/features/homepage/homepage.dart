import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';
import 'package:project_2359/core/widgets/section_header.dart';

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
          // Header
          _buildHeader(context),
          const SizedBox(height: 24),

          // Search Bar
          const SpecialSearchBar(),
          const SizedBox(height: 24),

          // Recent Activity
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
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24, top: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor.withOpacity(0),
            backgroundColor.withOpacity(0.9),
            backgroundColor,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppTheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.grid_view_rounded, "Home"),
            _buildNavItem(1, Icons.school_rounded, "Study"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
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
