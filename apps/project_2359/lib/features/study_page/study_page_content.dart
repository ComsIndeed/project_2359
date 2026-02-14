import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/features/study_page/widgets/active_material_card.dart';

class StudyPageContent extends StatelessWidget {
  const StudyPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildActiveMaterialsSection(context),
          const SizedBox(height: 32),
          _buildSourceLibrarySection(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildActiveMaterialsSection(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Active Materials",
          onViewAllTap: () {
            // TODO: View all active materials
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              ActiveMaterialCard(
                icon: FontAwesomeIcons.flask,
                title: "Advanced Chemistry",
                subtitle: "Week 4 • Molecules",
                progress: 0.75,
                backgroundGenerator: GenerationSeed.fromString(
                  "Advanced Chemistry",
                ),
              ),
              ActiveMaterialCard(
                icon: FontAwesomeIcons.bookOpen,
                title: "World History",
                subtitle: "The Renaissance",
                progress: 0.42,
                backgroundGenerator: GenerationSeed.fromString("World History"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSourceLibrarySection(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Source Library",
          onViewAllTap: () {
            // TODO: Manage sources
          },
        ),
        const SizedBox(height: 8),
        ActivityListItem(
          icon: const FaIcon(FontAwesomeIcons.filePdf),
          title: const Text("Introduction to Psychology"),
          subtitle: const Text("PDF • 3.4 MB"),
          onTap: () {},
        ),
        ActivityListItem(
          icon: const FaIcon(FontAwesomeIcons.link),
          title: const Text("Khan Academy: Calculus"),
          subtitle: const Text("Web Link • 5 Citations"),
          onTap: () {},
        ),
        ActivityListItem(
          icon: const FaIcon(FontAwesomeIcons.image),
          title: const Text("Whiteboard_Session_02"),
          subtitle: const Text("PNG • 1.2 MB"),
          onTap: () {},
        ),
      ],
    );
  }
}
