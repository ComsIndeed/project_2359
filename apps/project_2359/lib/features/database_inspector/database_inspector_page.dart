import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';

class DatabaseInspectorPage extends StatefulWidget {
  final AppDatabase db;
  const DatabaseInspectorPage({super.key, required this.db});

  @override
  State<DatabaseInspectorPage> createState() => _DatabaseInspectorPageState();
}

class _DatabaseInspectorPageState extends State<DatabaseInspectorPage> {
  TableInfo? _selectedTable;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _sortColumn;
  bool _sortAscending = true;
  bool _liveUpdate = false;
  int _currentPage = 0;
  final int _rowsPerPage = 20;

  @override
  void initState() {
    super.initState();
    final tables = widget.db.allTables.toList();
    if (tables.isNotEmpty) {
      _selectedTable = tables.first;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectTable(TableInfo table) {
    setState(() {
      _selectedTable = table;
      _searchQuery = '';
      _searchController.clear();
      _sortColumn = null;
      _sortAscending = true;
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tables = widget.db.allTables.toList();

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // --- Sidebar: Table List ---
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: cs.onSurface.withValues(alpha: 0.1)),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const ProjectBackButton(),
                        const SizedBox(width: 8),
                        Text(
                          'Database',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tables.length,
                      itemBuilder: (context, index) {
                        final table = tables[index];
                        final isSelected = _selectedTable == table;
                        return ListTile(
                          title: Text(
                            table.actualTableName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: cs.primary.withValues(alpha: 0.1),
                          onTap: () => _selectTable(table),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // --- Main: Table Content ---
            Expanded(
              child: Column(
                children: [
                  if (_selectedTable != null) ...[
                    _buildHeader(theme, cs),
                    const Divider(height: 1),
                    Expanded(child: _buildDataTable(theme, cs)),
                    _buildFooter(theme, cs),
                  ] else
                    const Center(child: Text('Select a table to inspect')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search in ${_selectedTable!.actualTableName}...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                filled: true,
                fillColor: cs.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (val) {
                setState(() {
                  _searchQuery = val;
                  _currentPage = 0;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Text('Live', style: TextStyle(fontSize: 12)),
              Switch.adaptive(
                value: _liveUpdate,
                onChanged: (val) => setState(() => _liveUpdate = val),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(ThemeData theme, ColorScheme cs) {
    final table = _selectedTable!;
    final columns = table.$columns;

    // Build the query
    final select = widget.db.select(table);

    return StreamBuilder<List<dynamic>>(
      stream: _liveUpdate ? select.watch() : select.get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var rows = List<dynamic>.from(snapshot.data ?? []);

        // In-memory searching
        if (_searchQuery.isNotEmpty) {
          rows = rows.where((row) {
            final map = row.toJson();
            return map.values.any(
              (v) =>
                  v?.toString().toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false,
            );
          }).toList();
        }

        // In-memory sorting
        if (_sortColumn != null) {
          rows.sort((a, b) {
            final mapA = a.toJson();
            final mapB = b.toJson();
            final valA = mapA[_sortColumn];
            final valB = mapB[_sortColumn];
            if (valA == null || valB == null) return 0;
            final cmp = valA.toString().compareTo(valB.toString());
            return _sortAscending ? cmp : -cmp;
          });
        }

        if (rows.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        // Pagination
        final start = _currentPage * _rowsPerPage;
        final end = (start + _rowsPerPage).clamp(0, rows.length);
        final paginatedRows = rows.sublist(start, end);

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 30,
              dataRowMaxHeight: 50,
              columnSpacing: 24,
              columns: columns.map((col) {
                return DataColumn(
                  label: Text(
                    col.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumn = col.name;
                      _sortAscending = ascending;
                    });
                  },
                );
              }).toList(),
              rows: paginatedRows.map((row) {
                final rowMap = row.toJson();
                return DataRow(
                  cells: columns.map((col) {
                    final value = rowMap[col.name];
                    return DataCell(_buildCellWidget(col, value));
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCellWidget(GeneratedColumn col, dynamic value) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Heuristic for foreign keys: ends with _id and value is not null
    final isLikelyFK = col.$name.endsWith('_id') && value != null;

    if (isLikelyFK) {
      // Try to find target table by guessing from column name prefix
      // e.g. folder_id -> study_folder_items, deck_id -> deck_items
      final colName = col.$name;
      final prefix = colName.substring(0, colName.length - 3); // remove _id

      try {
        final targetTable = widget.db.allTables.firstWhere(
          (t) =>
              t.actualTableName.contains(prefix) ||
              prefix.contains(t.actualTableName.replaceAll('_items', '')),
        );

        return InkWell(
          onTap: () => _navigateToRow(targetTable, value.toString()),
          child: Text(
            value.toString(),
            style: TextStyle(
              color: cs.primary,
              decoration: TextDecoration.underline,
              fontSize: 12,
            ),
          ),
        );
      } catch (_) {
        // Table not found by heuristic, show as normal text
      }
    }

    return Text(
      value?.toString() ?? 'NULL',
      style: TextStyle(
        fontSize: 12,
        color: value == null ? cs.onSurface.withValues(alpha: 0.3) : null,
      ),
    );
  }

  void _navigateToRow(TableInfo targetTable, String id) {
    setState(() {
      _selectedTable = targetTable;
      _searchQuery = id;
      _searchController.text = id;
      _currentPage = 0;
    });
  }

  Widget _buildFooter(ThemeData theme, ColorScheme cs) {
    // This is just a placeholder since we don't have the real count in this simple version
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
          ),
          Text(
            'Page ${_currentPage + 1}',
            style: const TextStyle(fontSize: 12),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() => _currentPage++),
          ),
        ],
      ),
    );
  }
}
