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
  int _currentPage = 0;
  final int _rowsPerPage = 20;

  Map<String, Set<dynamic>> _activeFilters = {};

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
      _activeFilters = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tables = widget.db.allTables.toList();
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedTable?.actualTableName ?? 'Database',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: const ProjectBackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Refresh',
            onPressed: () => setState(() {}),
          ),
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 20),
                tooltip: 'Tables',
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: isMobile
          ? Drawer(
              child: SafeArea(
                child: _buildTableList(theme, cs, tables, isMobile: true),
              ),
            )
          : null,
      body: SafeArea(
        child: isMobile
            ? _buildMainContent(theme, cs)
            : Row(
                children: [
                  // --- Sidebar: Table List ---
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: cs.onSurface.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: _buildTableList(theme, cs, tables, isMobile: false),
                  ),

                  // --- Main: Table Content ---
                  Expanded(child: _buildMainContent(theme, cs)),
                ],
              ),
      ),
    );
  }

  Widget _buildTableList(
    ThemeData theme,
    ColorScheme cs,
    List<TableInfo> tables, {
    required bool isMobile,
  }) {
    return Column(
      children: [
        if (isMobile)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tables',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                onTap: () {
                  _selectTable(table);
                  if (isMobile) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(ThemeData theme, ColorScheme cs) {
    if (_selectedTable == null) {
      return const Center(child: Text('Select a table to inspect'));
    }

    final table = _selectedTable!;
    final select = widget.db.customSelect('SELECT * FROM ${table.actualTableName}');

    return StreamBuilder<List<QueryRow>>(
      stream: select.get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allRows = snapshot.data ?? [];

        return Column(
          children: [
            _buildHeader(theme, cs, allRows),
            const Divider(height: 1),
            Expanded(child: _buildDataTable(theme, cs, allRows)),
            _buildFooter(theme, cs),
          ],
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme cs, List<QueryRow> allRows) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
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
          Expanded(
            flex: 2,
            child: _buildFilterButtons(theme, cs, allRows),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons(
    ThemeData theme,
    ColorScheme cs,
    List<QueryRow> allRows,
  ) {
    if (_selectedTable == null) return const SizedBox.shrink();

    final fkColumns =
        _selectedTable!.$columns.where((c) => c.$name.endsWith('_id')).toList();
    if (fkColumns.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            fkColumns.map((col) {
              final colName = col.$name;
              final label =
                  colName
                      .replaceAll('_id', '')
                      .replaceAll('_', ' ')
                      .toUpperCase();
              final activeFilters = _activeFilters[colName];
              final hasActive = activeFilters != null && activeFilters.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(
                    hasActive ? '$label (${activeFilters.length})' : label,
                    style: const TextStyle(fontSize: 11),
                  ),
                  selected: hasActive,
                  onSelected: (_) => _showFilterDialog(colName, allRows),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _showFilterDialog(String colName, List<QueryRow> allRows) {
    final uniqueValues = allRows.map((r) => r.data[colName]).toSet().toList();
    uniqueValues.sort(
      (a, b) => a?.toString().compareTo(b?.toString() ?? '') ?? 0,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentFilters = _activeFilters[colName] ?? {};
            return AlertDialog(
              title: Text('Filter by $colName'),
              content: SizedBox(
                width: 300,
                child:
                    uniqueValues.isEmpty
                        ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No values available'),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: uniqueValues.length,
                          itemBuilder: (context, index) {
                            final val = uniqueValues[index];
                            final isSelected = currentFilters.contains(val);
                            return CheckboxListTile(
                              title: Text(val?.toString() ?? 'NULL'),
                              value: isSelected,
                              onChanged: (checked) {
                                _toggleFilter(colName, val);
                                setDialogState(() {});
                              },
                            );
                          },
                        ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => _activeFilters.remove(colName));
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleFilter(String column, dynamic value) {
    setState(() {
      final filters = _activeFilters[column] ?? {};
      if (filters.contains(value)) {
        filters.remove(value);
      } else {
        filters.add(value);
      }
      if (filters.isEmpty) {
        _activeFilters.remove(column);
      } else {
        _activeFilters[column] = filters;
      }
      _currentPage = 0;
    });
  }

  Widget _buildDataTable(
    ThemeData theme,
    ColorScheme cs,
    List<QueryRow> allRows,
  ) {
    final table = _selectedTable!;
    final columns = table.$columns.toList();

    var rows = List<QueryRow>.from(allRows);

    // In-memory searching
    if (_searchQuery.isNotEmpty) {
      rows =
          rows.where((row) {
            return row.data.values.any(
              (v) =>
                  v?.toString().toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false,
            );
          }).toList();
    }

    // In-memory filtering
    if (_activeFilters.isNotEmpty) {
      rows =
          rows.where((row) {
            return _activeFilters.entries.every((entry) {
              final val = row.data[entry.key];
              return entry.value.contains(val);
            });
          }).toList();
    }

    // In-memory sorting
    if (_sortColumn != null) {
      rows.sort((a, b) {
        final valA = a.data[_sortColumn];
        final valB = b.data[_sortColumn];
        if (valA == null || valB == null) return 0;
        final cmp = valA.toString().compareTo(valB.toString());
        return _sortAscending ? cmp : -cmp;
      });
    }

    if (rows.isEmpty) {
      return const Center(child: Text('No data found'));
    }

    // Pagination
    final totalRows = rows.length;
    final start = (_currentPage * _rowsPerPage).clamp(0, totalRows);
    final end = (start + _rowsPerPage).clamp(0, totalRows);
    final paginatedRows = rows.sublist(start, end);

    final sortIndex =
        _sortColumn == null
            ? null
            : columns.indexWhere((c) => c.name == _sortColumn);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: sortIndex == -1 ? null : sortIndex,
          sortAscending: _sortAscending,
          headingRowHeight: 40,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 50,
          columnSpacing: 24,
          columns:
              columns.map((col) {
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
          rows:
              paginatedRows.map((row) {
                return DataRow(
                  cells:
                      columns.map((col) {
                        final value = row.data[col.name];
                        return DataCell(_buildCellWidget(col, value));
                      }).toList(),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildCellWidget(GeneratedColumn col, dynamic value) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Heuristic for foreign keys: ends with _id and value is not null
    final isLikelyFK = col.$name.endsWith('_id') && value != null;

    if (isLikelyFK) {
      // Try to find target table by guessing from column name prefix
      // e.g. collection_id -> collection_items, deck_id -> deck_items
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
