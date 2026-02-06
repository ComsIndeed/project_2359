import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sources",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SpecialSearchBar(),
              const SizedBox(height: 20),
              Text(
                "Import Sources",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.15,
                children: [
                  CardButton(
                    icon: Icons.description_rounded,
                    label: "Document",
                    subLabel: "pdf, docx, pptx, slides",
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.document_scanner_rounded,
                    label: "Photo",
                    subLabel: "whiteboard, diagrams",
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.mic_rounded,
                    label: "Audio",
                    subLabel: "lecture, mp3, memo",
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.style_rounded,
                    label: "Flashcards",
                    subLabel: ".apkg, .csv, quizlet",
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.cloud_queue_rounded,
                    label: "Cloud Drive",
                    subLabel: "Google, OneDrive",
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.link_rounded,
                    label: "Website",
                    subLabel: "YouTube, Wiki, Articles",
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.edit_note_rounded,
                    label: "Note App",
                    subLabel: "Notion, Obsidian",
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.videocam_rounded,
                    label: "Video",
                    subLabel: "Coming Soon",
                    onTap: null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
