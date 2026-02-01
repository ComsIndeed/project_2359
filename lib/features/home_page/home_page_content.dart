import 'package:flutter/material.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 100), // Bottom padding for navigation bar
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
