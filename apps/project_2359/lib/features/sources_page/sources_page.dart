import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/section_header.dart';
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SpecialSearchBar(),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: "Import Sources",
                    onViewAllTap: null, // No 'View All' needed for this grid
                  ),
                  const SizedBox(height: 8),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.7,
                children: [
                  CardButton(
                    icon: Icons.description_rounded,
                    label: "Document",
                    subLabel: "pdf, docx, pptx",
                    layoutDirection: CardLayoutDirection.horizontal,
                    isCompact: true,
                    accentColor: AppTheme.primary,
                    onTap: _importDocument,
                  ),
                  CardButton(
                    icon: Icons.perm_media_rounded,
                    label: "Media",
                    subLabel: "photos, audio, video",
                    layoutDirection: CardLayoutDirection.horizontal,
                    isCompact: true,
                    accentColor: const Color(0xFFFF9F43), // Vibrant Orange
                    onTap: () {},
                  ),
                  CardButton(
                    icon: Icons.style_rounded,
                    label: "Flashcards",
                    subLabel: ".apkg, .csv, quizlet",
                    layoutDirection: CardLayoutDirection.horizontal,
                    isCompact: true,
                    accentColor: AppTheme.success,
                    onTap: null,
                  ),
                  CardButton(
                    icon: Icons.cloud_queue_rounded,
                    label: "Cloud Drive",
                    subLabel: "Google, OneDrive",
                    layoutDirection: CardLayoutDirection.horizontal,
                    isCompact: true,
                    accentColor: const Color(0xFF00D2D3), // Cyan
                    onTap: null,
                  ),
                  CardButton(
                    icon: Icons.link_rounded,
                    label: "Website",
                    subLabel: "YouTube, Wiki",
                    layoutDirection: CardLayoutDirection.horizontal,
                    isCompact: true,
                    accentColor: const Color(0xFF5f27cd), // Dark Purple
                    onTap: null,
                  ),
                  CardButton(
                    icon: Icons.edit_note_rounded,
                    label: "Note App",
                    subLabel: "Notion, Obsidian",
                    layoutDirection: CardLayoutDirection.horizontal,
                    isCompact: true,
                    accentColor: AppTheme.warning,
                    onTap: null,
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 32),
                  SectionHeader(
                    title: "Your Sources",
                    onViewAllTap: () {
                      // TODO: Manage sources
                    },
                  ),
                  const SizedBox(height: 12),
                  // Placeholder for empty state or list
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.source_rounded,
                            size: 48,
                            color: AppTheme.textSecondary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No sources added yet.",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textSecondary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80), // Bottom padding
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _importDocument() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "docx", "pptx"],
    );

    if (file == null) return;

    final filePath = file.files.first.path!;
    final fileName = file.files.first.name;
    final fileExtension = file.files.first.extension;
  }
}
