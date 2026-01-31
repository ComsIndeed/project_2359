import 'package:flutter/material.dart';

import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';
import 'package:project_2359/core/widgets/special_navigation_bar.dart';
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
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [_buildHomeContent(context), StudyPageContent()],
        ),
      ),
      bottomNavigationBar: SpecialNavigationBar(
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
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text("New Set"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_rounded, size: 18),
                  color: Colors.white70,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
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

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Project 2359",
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
