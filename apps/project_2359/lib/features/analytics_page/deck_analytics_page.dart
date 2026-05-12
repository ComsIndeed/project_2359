import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeckAnalyticsPage extends StatefulWidget {
  final String deckId;
  final String deckName;

  const DeckAnalyticsPage({
    super.key,
    required this.deckId,
    required this.deckName,
  });

  @override
  State<DeckAnalyticsPage> createState() => _DeckAnalyticsPageState();
}

class _DeckAnalyticsPageState extends State<DeckAnalyticsPage> {
  bool _isLoading = true;
  List<_ChartData> _reviewHistory = [];
  Map<int, int> _maturityData = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = context.read<AppDatabase>();
    
    // 1. Fetch Review History (last 30 days)
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    final events = await (db.select(db.studySessionEvents)
          ..where((t) => t.deckId.equals(widget.deckId))
          ..where((t) => t.reviewedAt.isBiggerOrEqualValue(thirtyDaysAgo.toIso8601String())))
        .get();

    final Map<String, int> dailyCounts = {};
    for (var i = 0; i <= 30; i++) {
      final date = thirtyDaysAgo.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      dailyCounts[dateStr] = 0;
    }

    for (final event in events) {
      final datePart = event.reviewedAt.split('T')[0];
      if (dailyCounts.containsKey(datePart)) {
        dailyCounts[datePart] = dailyCounts[datePart]! + 1;
      }
    }

    _reviewHistory = dailyCounts.entries
        .map((e) => _ChartData(DateTime.parse(e.key), e.value))
        .toList();

    // 2. Fetch Card Maturity (States)
    final cards = await (db.select(db.cardItems)
          ..where((t) => t.deckId.equals(widget.deckId)))
        .get();

    final maturity = <int, int>{0: 0, 1: 0, 2: 0, 3: 0}; // new, learning, review, relearning
    for (final card in cards) {
      final state = card.spacedState ?? 0;
      maturity[state] = (maturity[state] ?? 0) + 1;
    }
    _maturityData = maturity;

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: const ProjectBackButton(),
        title: Text('${widget.deckName} Stats'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildChartCard(
                    title: "Daily Reviews (Last 30 Days)",
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(),
                      series: <CartesianSeries<_ChartData, DateTime>>[
                        ColumnSeries<_ChartData, DateTime>(
                          dataSource: _reviewHistory,
                          xValueMapper: (data, _) => data.date,
                          yValueMapper: (data, _) => data.count,
                          color: theme.colorScheme.primary,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    title: "Card Maturity",
                    child: SfCircularChart(
                      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                      series: <CircularSeries<_MaturityData, String>>[
                        PieSeries<_MaturityData, String>(
                          dataSource: [
                            _MaturityData('New', _maturityData[0] ?? 0, Colors.grey),
                            _MaturityData('Learning', _maturityData[1] ?? 0, Colors.blue),
                            _MaturityData('Review', _maturityData[2] ?? 0, Colors.green),
                            _MaturityData('Relearning', _maturityData[3] ?? 0, Colors.orange),
                          ],
                          xValueMapper: (data, _) => data.label,
                          yValueMapper: (data, _) => data.value,
                          pointColorMapper: (data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 300, child: child),
        ],
      ),
    );
  }
}

class _ChartData {
  final DateTime date;
  final int count;
  _ChartData(this.date, this.count);
}

class _MaturityData {
  final String label;
  final int value;
  final Color color;
  _MaturityData(this.label, this.value, this.color);
}
