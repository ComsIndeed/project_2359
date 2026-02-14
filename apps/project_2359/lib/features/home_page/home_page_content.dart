import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';
import 'package:project_2359/core/widgets/tap_to_slide_up.dart';
import 'package:project_2359/features/settings_page/settings_page.dart';

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
            icon: const FaIcon(FontAwesomeIcons.circleQuestion),
            title: const Text("Cell Biology Quiz"),
            subtitle: const Text("Score: 8/10 • 2h ago"),
            accentColor: Colors.blue,
            onTap: () {},
          ),
          ActivityListItem(
            icon: const FaIcon(FontAwesomeIcons.fileLines),
            title: const Text("Lecture Notes: Week 3"),
            subtitle: const Text("Added to Library • 5h ago"),
            accentColor: Colors.pink,
            onTap: () {},
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/app_icon.png', height: 40),
        SizedBox(width: 8),
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
        Spacer(),
        TapToSlideUp(
          page: const SettingsPage(),
          builder: (pushPage) {
            return IconButton(
              onPressed: pushPage,
              icon: const FaIcon(FontAwesomeIcons.gear),
            );
          },
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
