import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/widgets/expandable_fab.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/features/card_creation_page/card_creation_page.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class NewItemMenu extends StatefulWidget {
  final VoidCallback? onActionCompleted;
  final String? activeFolderId;

  const NewItemMenu({super.key, this.onActionCompleted, this.activeFolderId});

  @override
  State<NewItemMenu> createState() => _NewItemMenuState();
}

class _NewItemMenuState extends State<NewItemMenu> {
  final TextEditingController folderNameController = TextEditingController();
  bool isCreatingFolder = false;

  @override
  void initState() {
    super.initState();
    folderNameController.addListener(() {
      setState(() {}); // Trigger rebuild to show/hide the button
    });
  }

  Future<void> createFolder() async {
    final name = folderNameController.text.trim();
    if (name.isEmpty) return;

    setState(() => isCreatingFolder = true);
    try {
      final service = context.read<StudyDatabaseService>();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await service.insertFolder(
        StudyFolderItemsCompanion.insert(
          id: id,
          name: name,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );

      if (mounted) {
        folderNameController.clear();
        if (widget.onActionCompleted != null) {
          widget.onActionCompleted!();
        } else {
          try {
            ExpandableFab.of(context).close();
          } catch (_) {
            Navigator.maybePop(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isCreatingFolder = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // NEW COLLECTION CREATION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NEW COLLECTION",
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: folderNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Name...",
                          hintStyle: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.3),
                            fontSize: 15,
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: FaIcon(
                              FontAwesomeIcons.folderPlus,
                              size: 16,
                              color: cs.primary.withValues(alpha: 0.6),
                            ),
                          ),
                          filled: true,
                          fillColor: cs.onSurface.withValues(alpha: 0.04),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: cs.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => createFolder(),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: folderNameController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: isCreatingFolder
                                    ? null
                                    : createFolder,
                                icon: isCreatingFolder
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.check,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                style: IconButton.styleFrom(
                                  backgroundColor: cs.primary,
                                  fixedSize: const Size(54, 54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SEPARATOR
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Divider(
                  color: cs.onSurface.withValues(alpha: 0.08),
                  indent: 32,
                  endIndent: 32,
                ),
                Container(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.98,
                  ), // Match FAB bg
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "OR",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST TILES FOR MORE OPTIONS
          ProjectListGroup(
            backgroundColor:
                Colors.transparent, // Let FAB background show through
            margin: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              ProjectListTile.simple(
                label: "New Card Pack",
                icon: FontAwesomeIcons.layerGroup,
                showDivider: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardCreationPage(
                        folderId: widget.activeFolderId ?? "default",
                      ),
                    ),
                  );
                  if (widget.onActionCompleted != null) {
                    widget.onActionCompleted!();
                  } else {
                    try {
                      ExpandableFab.of(context).close();
                    } catch (_) {}
                  }
                },
                showChevron: false,
              ),
              ProjectListTile.simple(
                label: "Scan Documents",
                icon: FontAwesomeIcons.camera,
                showDivider: true,
                onTap: () {},
                showChevron: false,
              ),
              ProjectListTile.simple(
                label: "Import Source",
                icon: FontAwesomeIcons.fileImport,
                showDivider: false,
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: true,
                    withData: true,
                    allowedExtensions: ["pdf", "docx", "pptx", "txt"],
                  );

                  if (result == null || !context.mounted) return;

                  context.read<SourcesPageBloc>().add(
                    ImportDocumentsEvent(
                      result.files,
                      folderId: widget.activeFolderId,
                    ),
                  );

                  if (widget.onActionCompleted != null) {
                    widget.onActionCompleted!();
                  } else {
                    try {
                      ExpandableFab.of(context).close();
                    } catch (_) {}
                  }
                },
                showChevron: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
