import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/widgets/adaptive_pane_layout.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
import 'package:project_2359/features/anki_import_page/services/anki_import_service.dart';
import 'package:project_2359/features/anki_import_page/widgets/import_deck_preview.dart';
import 'package:project_2359/features/anki_import_page/widgets/import_result_dialog.dart';
import 'package:project_2359/features/anki_import_page/widgets/import_side_panel.dart';
import 'package:provider/provider.dart';

class AnkiImportPage extends StatefulWidget {
  const AnkiImportPage({super.key});

  @override
  State<AnkiImportPage> createState() => _AnkiImportPageState();
}

class _AnkiImportPageState extends State<AnkiImportPage> {
  AnkiImportData? _stagedData;
  bool _isParsing = false;
  bool _isImporting = false;
  String? _errorMessage;
  String _importPhase = '';
  double _importProgress = 0;

  bool _preserveFsrsState = true;
  String _fsrsParams = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DesktopTitleBarController>()
        ..setCenteredTitle('Import Anki Deck')
        ..setHideBack(false);
    });
  }

  @override
  void dispose() {
    context.read<DesktopTitleBarController>().reset();
    super.dispose();
  }

  // ── File picking & parsing ───────────────────────────────────────────────

  Future<void> _pickAndParse() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apkg'],
      withData: false, // we'll read via path
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final path = file.path;
    if (path == null) {
      setState(() => _errorMessage = 'Could not access the selected file.');
      return;
    }

    setState(() {
      _isParsing = true;
      _errorMessage = null;
      _stagedData = null;
    });

    try {
      final data = await AnkiImportService.parseApkg(path, file.name);
      if (mounted) setState(() => _stagedData = data);
    } on AnkiImportError catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Unexpected error: $e');
      }
    } finally {
      if (mounted) setState(() => _isParsing = false);
    }
  }

  // ── Collection picker + commit ───────────────────────────────────────────

  Future<void> _startImport() async {
    final data = _stagedData;
    if (data == null) return;

    final db = context.read<AppDatabase>();
    final service = context.read<StudyDatabaseService>();

    // Build collection list for the picker
    final allCollections = await service.getAllCollections();
    if (!mounted) return;

    final picked = await showCollectionPickerDialog(
      context,
      allCollections
          .map((c) => (id: c.id, name: c.name))
          .toList(),
    );
    if (picked == null || !mounted) return;

    setState(() {
      _isImporting = true;
      _importPhase = 'Starting…';
      _importProgress = 0;
    });

    try {
      // Create the collection if it's new (id not in existing list)
      final existingIds = allCollections.map((c) => c.id).toSet();
      if (!existingIds.contains(picked.id)) {
        await service.insertCollection(
          StudyCollectionItemsCompanion.insert(
            id: picked.id,
            name: picked.name,
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          ),
        );
      }

      final result = await AnkiImportService.commitImport(
        data: data,
        collectionId: picked.id,
        collectionName: picked.name,
        db: db,
        preserveFsrsState: _preserveFsrsState,
        onProgress: (phase, progress) {
          if (mounted) {
            setState(() {
              _importPhase = phase;
              _importProgress = progress;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isImporting = false;
          _stagedData = null;
        });
        await showDialog<void>(
          context: context,
          builder: (_) => ImportResultDialog(
            result: result,
            onViewCollection: () => Navigator.of(context).maybePop(),
          ),
        );
      }
    } on AnkiImportError catch (e) {
      if (mounted) {
        setState(() {
          _isImporting = false;
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isImporting = false;
          _errorMessage = 'Import failed: $e';
        });
      }
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptivePaneLayout(
        key: const ValueKey('anki_import_pane'),
        masterWidth: 300,
        master: (context, controller) => _buildMaster(),
        detail: (context, controller) => _buildDetail(),
        wrapDetail: false,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildMaster() {
    return ImportSidePanel(
      stagedData: _stagedData,
      isLoading: _isParsing,
      errorMessage: _errorMessage,
      preserveFsrsState: _preserveFsrsState,
      fsrsParams: _fsrsParams,
      onPreserveFsrsChanged: (v) => setState(() => _preserveFsrsState = v),
      onFsrsParamsChanged: (v) => setState(() => _fsrsParams = v),
      onPickFile: _pickAndParse,
      onImport: (_stagedData != null && !_isImporting) ? _startImport : null,
    );
  }

  Widget _buildDetail() {
    if (_isImporting) return _buildImportProgress();
    if (_stagedData != null) {
      return ImportDeckPreview(data: _stagedData!);
    }
    return _buildEmptyDetail();
  }

  Widget _buildEmptyDetail() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.fileArrowDown,
            size: 64,
            color: cs.onSurface.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 24),
          Text(
            'Select an Anki deck file to preview its contents',
            style: theme.textTheme.titleMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.35),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Supports .apkg files from Anki 2.0 and newer',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportProgress() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.fileImport,
                size: 48,
                color: cs.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Text(
                _importPhase,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _importProgress,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_importProgress * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
