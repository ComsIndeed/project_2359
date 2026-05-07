import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/card_button.dart';
import 'package:project_2359/core/widgets/section_header.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';
import 'package:project_2359/core/widgets/tap_to_slide.dart';
import 'package:project_2359/features/source_page/source_page.dart';
import 'package:project_2359/features/sources_page/source_list_item.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_state.dart';

class CollectionSourcesPage extends StatefulWidget {
  final String collectionId;
  final String collectionName;

  const CollectionSourcesPage({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  static Future<void> show(
    BuildContext context,
    String collectionId,
    String collectionName,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CollectionSourcesPage(collectionId: collectionId, collectionName: collectionName),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<CollectionSourcesPage> createState() => _CollectionSourcesPageState();
}

class _CollectionSourcesPageState extends State<CollectionSourcesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Load sources for this collection
    context.read<SourcesPageBloc>().add(
      LoadSourcesEvent(collectionId: widget.collectionId),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundAlt,
      body: BlocBuilder<SourcesPageBloc, SourcesPageState>(
        builder: (context, state) {
          final allSources = state is SourcesPageStateLoaded
              ? state.sources
              : <SourceItem>[];

          final sources = allSources.where((s) {
            if (_searchQuery.isEmpty) return true;
            return s.label.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          children: [
                            ProjectBackButton(
                              onPressed: () {
                                // Reload all sources when going back to global state if necessary
                                context.read<SourcesPageBloc>().add(
                                  const LoadSourcesEvent(),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.collectionName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: cs.primary,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                  ),
                                  Text(
                                    "Collection Sources",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(fontSize: 28),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SpecialSearchBar(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: "Import to Collection",
                        onViewAllTap: null,
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
                        icon: FontAwesomeIcons.fileLines,
                        label: "Document",
                        subLabel: "pdf, docx, pptx",
                        layoutDirection: CardLayoutDirection.horizontal,
                        isCompact: true,
                        accentColor: cs.primary,
                        onTap: () => _importDocument(context),
                      ),
                      CardButton(
                        icon: FontAwesomeIcons.cloud,
                        label: "Cloud Drive",
                        subLabel: "Google, OneDrive",
                        layoutDirection: CardLayoutDirection.horizontal,
                        isCompact: true,
                        accentColor: const Color(0xFF00D2D3),
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
                        title: "Collection Sources",
                        onViewAllTap: null,
                      ),
                      const SizedBox(height: 12),

                      if (sources.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sources.length,
                          itemBuilder: (context, index) {
                            final source = sources[index];

                            return TapToSlide(
                              page: _SourcePageLoader(source: source),
                              direction: SlideDirection.left,
                              builder: (pushPage) => SourceListItem(
                                onTap: pushPage,
                                icon: FontAwesomeIcons.fileLines,
                                title: source.label,
                                subtitle: source.path ?? "PDF Document",
                                initialStatus: SourceIndexingStatus.indexed,
                                onDelete: () => context
                                    .read<SourcesPageBloc>()
                                    .add(DeleteSourceEvent(source.id)),
                              ),
                            );
                          },
                        ),

                      if (sources.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.boxOpen,
                                  size: 48,
                                  color: cs.onSurface.withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? "No matching sources in collection."
                                      : "No sources in this collection.",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: cs.onSurface.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 80),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _importDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      withData: true,
      allowedExtensions: ["pdf", "docx", "pptx"],
    );

    if (result == null) return;

    if (context.mounted) {
      context.read<SourcesPageBloc>().add(
        ImportDocumentsEvent(result.files, collectionId: widget.collectionId),
      );
    }
  }
}

class _SourcePageLoader extends StatefulWidget {
  final SourceItem source;

  const _SourcePageLoader({required this.source});

  @override
  State<_SourcePageLoader> createState() => _SourcePageLoaderState();
}

class _SourcePageLoaderState extends State<_SourcePageLoader> {
  SourceItemBlob? _blob;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBlob();
  }

  Future<void> _loadBlob() async {
    // Re-use SourceService via context
    final sourceService = SourceService(context.read<AppDatabase>());
    final blob = await sourceService.getSourceBlobBySourceId(widget.source.id);
    if (mounted) {
      setState(() {
        _blob = blob;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_blob == null) {
      return Scaffold(
        appBar: AppBar(leading: const ProjectBackButton()),
        body: const Center(child: Text("File data not found")),
      );
    }

    return SourcePage(fileBytes: _blob!.bytes, title: widget.source.label);
  }
}
