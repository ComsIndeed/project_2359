import 'package:flutter/material.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/app_controller.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:project_2359/core/widgets/project_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

class DeckSettingsPage extends StatefulWidget {
  final String deckId;
  final String deckName;

  const DeckSettingsPage({
    super.key,
    required this.deckId,
    required this.deckName,
  });

  @override
  State<DeckSettingsPage> createState() => _DeckSettingsPageState();
}

class _DeckSettingsPageState extends State<DeckSettingsPage> {
  DeckConfigItem? _config;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final dbService = context.read<AppController>().studyDatabaseService;
    final deck = await dbService.getDeckById(widget.deckId);
    
    if (deck?.configId != null) {
      _config = await dbService.getDeckConfigById(deck!.configId!);
    } else {
      // Create a default config if it doesn't exist
      final newConfigId = const Uuid().v4();
      final newConfig = DeckConfigItemsCompanion.insert(
        id: newConfigId,
        name: drift.Value('${widget.deckName} Config'),
      );
      await dbService.insertDeckConfig(newConfig);
      await dbService.updateDeck(DeckItemsCompanion(
        id: drift.Value(widget.deckId),
        configId: drift.Value(newConfigId),
      ));
      _config = await dbService.getDeckConfigById(newConfigId);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateConfig(DeckConfigItemsCompanion companion) async {
    if (_config == null) return;
    final dbService = context.read<AppController>().studyDatabaseService;
    await dbService.updateDeckConfig(companion.copyWith(id: drift.Value(_config!.id)));
    _loadConfig(); // Reload
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: const ProjectBackButton(),
        title: Text('${widget.deckName} Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Daily Limits"),
                  const SizedBox(height: 12),
                  ProjectListGroup(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    children: [
                      _buildNumberTile(
                        label: "New Cards per Day",
                        value: _config!.newCardsPerDay,
                        onChanged: (val) => _updateConfig(DeckConfigItemsCompanion(newCardsPerDay: drift.Value(val))),
                      ),
                      _buildNumberTile(
                        label: "Maximum Reviews per Day",
                        value: _config!.reviewsPerDay,
                        onChanged: (val) => _updateConfig(DeckConfigItemsCompanion(reviewsPerDay: drift.Value(val))),
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel("Scheduling"),
                  const SizedBox(height: 12),
                  ProjectListGroup(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    children: [
                      _buildTextTile(
                        label: "Learning Steps",
                        subLabel: "Minutes between steps (e.g., 1, 10)",
                        value: _config!.learningSteps,
                        onChanged: (val) => _updateConfig(DeckConfigItemsCompanion(learningSteps: drift.Value(val))),
                      ),
                      ProjectListTile.simple(
                        label: "Bury Related Siblings",
                        trailing: Switch(
                          value: _config!.burySiblings,
                          onChanged: (val) => _updateConfig(DeckConfigItemsCompanion(burySiblings: drift.Value(val))),
                        ),
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel("New Card Order"),
                  const SizedBox(height: 12),
                  ProjectListGroup(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    children: [
                      RadioListTile<int>(
                        title: const Text("Added Order"),
                        value: 0,
                        groupValue: _config!.newCardOrder,
                        onChanged: (val) => _updateConfig(DeckConfigItemsCompanion(newCardOrder: drift.Value(val!))),
                      ),
                      RadioListTile<int>(
                        title: const Text("Random Order"),
                        value: 1,
                        groupValue: _config!.newCardOrder,
                        onChanged: (val) => _updateConfig(DeckConfigItemsCompanion(newCardOrder: drift.Value(val!))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildNumberTile({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    bool showDivider = true,
  }) {
    return ProjectListTile.simple(
      label: label,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            onPressed: () => onChanged(value - 1),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
      showDivider: showDivider,
    );
  }

  Widget _buildTextTile({
    required String label,
    required String subLabel,
    required String value,
    required ValueChanged<String> onChanged,
    bool showDivider = true,
  }) {
    return ProjectListTile.simple(
      label: label,
      subLabel: subLabel,
      trailing: const Icon(Icons.edit, size: 16),
      onTap: () async {
        final controller = TextEditingController(text: value);
        final newValue = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(label),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: "e.g., 1, 10"),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Save")),
            ],
          ),
        );
        if (newValue != null) onChanged(newValue);
      },
      showDivider: showDivider,
    );
  }
}
