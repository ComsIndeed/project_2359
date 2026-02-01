import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/activity_list_item.dart';
import 'package:project_2359/features/study_page/widgets/study_page_header.dart';
import 'package:project_2359/features/study_page/widgets/active_material_card.dart';

class StudyPageContent extends StatelessWidget {
  const StudyPageContent({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudyPageHeader(
            onNewTap: () {
              // TODO: Implement new study material creation
            },
          ),
          const SizedBox(height: 16),
          _buildActiveMaterialsSection(context),
          const SizedBox(height: 32),
          _buildSourceLibrarySection(context),
          const SizedBox(height: 100), // Bottom padding for navigation bar
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
          height: 240, // Height for the cards
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: const [
              ActiveMaterialCard(
                icon: Icons.science,
                title: "Advanced Chemistry",
                subtitle: "Week 4 • Molecules",
                progress: 0.75,
                accentColor: Color(0xFF7B61FF), // Custom purple
              ),
              ActiveMaterialCard(
                icon: Icons.history_edu,
                title: "World History",
                subtitle: "The Renaissance",
                progress: 0.42,
                accentColor: Color(0xFFFF9F43), // Custom orange
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
          icon: Icons.picture_as_pdf,
          title: "Introduction to Psychology",
          subtitle: "PDF • 3.4 MB",
          iconColor: AppTheme.textSecondary,
          onTap: () {},
        ),
        ActivityListItem(
          icon: Icons.link,
          title: "Khan Academy: Calculus",
          subtitle: "Web Link • 5 Citations",
          iconColor: AppTheme.textSecondary,
          onTap: () {},
        ),
        ActivityListItem(
          icon: Icons.image,
          title: "Whiteboard_Session_02",
          subtitle: "PNG • 1.2 MB",
          iconColor: AppTheme.textSecondary,
          onTap: () {},
        ),
      ],
    );
  }
}
