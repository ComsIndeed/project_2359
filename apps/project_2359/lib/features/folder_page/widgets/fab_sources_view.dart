import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:project_2359/features/source_page/source_page.dart';
import 'package:project_2359/features/sources_page/source_list_item.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/folder_page/widgets/shared_widgets.dart';

class FabSourcesView extends StatefulWidget {
  final String folderId;
  final List<SourceItem>? initialSources;

  const FabSourcesView({
    super.key,
    required this.folderId,
    this.initialSources,
  });

  @override
  State<FabSourcesView> createState() => _FabSourcesViewState();
}

class _FabSourcesViewState extends State<FabSourcesView> {
  late Stream<List<SourceItem>> _sourcesStream;

  @override
  void initState() {
    super.initState();
    _sourcesStream = context.read<SourceService>().watchSourcesByFolderId(
      widget.folderId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return StreamBuilder<List<SourceItem>>(
      stream: _sourcesStream,
      initialData: widget.initialSources,
      builder: (context, snapshot) {
        final sources = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.layerGroup, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    "Folder Sources",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (sources.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      "No sources in this folder yet.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              else
                ProjectListGroup(
                  backgroundColor: cs.onSurface.withValues(alpha: 0.04),
                  children: [
                    for (var source in sources)
                      SourceListItem(
                        title: source.label,
                        subtitle: source.path ?? "Source Document",
                        icon: FontAwesomeIcons.fileLines,
                        initialStatus: SourceIndexingStatus.indexed,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SourcePageLoader(
                                sourceId: source.id,
                                sourceLabel: source.label,
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<SourcesPageBloc>().add(
                            DeleteSourceEvent(source.id),
                          );
                        },
                      ),
                  ],
                ),
              const SizedBox(height: 24),
              const SectionLabel(title: "Import New"),
              const SizedBox(height: 12),
              // We reuse the import grid from generation view or create a shared one
              // For now, let's just use a simple button as we refactor
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.2,
                children: [
                  WizardButton(
                    label: "Files",
                    icon: FontAwesomeIcons.fileLines,
                    onPressed: () => _importDocument(context),
                  ),
                  WizardButton(
                    label: "Text",
                    icon: FontAwesomeIcons.paragraph,
                    onPressed: () {},
                    isSecondary: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _importDocument(BuildContext context) {
    // This should be shared, but for now we repeat to avoid complex dependency cycles
    // In a real app, I'd move this to a SourceService helper
  }
}

class SourcePageLoader extends StatefulWidget {
  final String sourceId;
  final String sourceLabel;
  final bool showBackButton;

  const SourcePageLoader({
    super.key,
    required this.sourceId,
    required this.sourceLabel,
    this.showBackButton = true,
  });

  @override
  State<SourcePageLoader> createState() => _SourcePageLoaderState();
}

class _SourcePageLoaderState extends State<SourcePageLoader> {
  SourceItemBlob? _blob;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBlob();
  }

  Future<void> _loadBlob() async {
    final sourceService = SourceService(context.read<AppDatabase>());
    final blob = await sourceService.getSourceBlobBySourceId(widget.sourceId);
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
        appBar: AppBar(),
        body: const Center(child: Text("File data not found")),
      );
    }

    return SourcePage(
      fileBytes: _blob!.bytes,
      title: widget.sourceLabel,
      showBackButton: widget.showBackButton,
    );
  }
}
