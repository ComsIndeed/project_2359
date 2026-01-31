import 'package:flutter/material.dart';

import 'package:project_2359/core/widgets/custom_search_bar.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/action_grid_item.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time to focus, Alex",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        "Good Evening",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                    ), // Placeholder
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              const CustomSearchBar(),
              const SizedBox(height: 24),

              // Quick Actions
              const SectionHeader(title: "Tools"),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  const ActionGridItem(
                    icon: Icons.auto_awesome,
                    label: "Generator",
                    subLabel: "Create quizzes",
                    iconColor: Colors.blueAccent,
                  ),
                  const ActionGridItem(
                    icon: Icons.timer,
                    label: "Study Mode",
                    subLabel: "Focus timer",
                    iconColor: Colors.greenAccent,
                  ),
                  const ActionGridItem(
                    icon: Icons.bar_chart,
                    label: "Scoreboard",
                    subLabel: "Track progress",
                    iconColor: Colors.orangeAccent,
                  ),
                  const ActionGridItem(
                    icon: Icons.folder,
                    label: "Sources",
                    subLabel: "Manage files",
                    iconColor: Colors.purpleAccent,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Activity
              SectionHeader(title: "Recent Activity", onViewAllTap: () {}),
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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_rounded),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: "Study",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
