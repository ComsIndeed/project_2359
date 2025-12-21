import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock data
  final int _totalReviews = 2847;
  final int _retention = 92;
  final int _streak = 14;
  final bool _darkMode = true;

  final Map<DateTime, int> _heatmapData = {
    DateTime.now().subtract(const Duration(days: 30)): 5,
    DateTime.now().subtract(const Duration(days: 29)): 8,
    DateTime.now().subtract(const Duration(days: 28)): 12,
    DateTime.now().subtract(const Duration(days: 27)): 0,
    DateTime.now().subtract(const Duration(days: 26)): 7,
    DateTime.now().subtract(const Duration(days: 25)): 9,
    DateTime.now().subtract(const Duration(days: 20)): 10,
    DateTime.now().subtract(const Duration(days: 15)): 15,
    DateTime.now().subtract(const Duration(days: 10)): 6,
    DateTime.now().subtract(const Duration(days: 5)): 11,
    DateTime.now().subtract(const Duration(days: 3)): 8,
    DateTime.now().subtract(const Duration(days: 1)): 13,
    DateTime.now(): 20,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with total reviews
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
              decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Total Reviews',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _totalReviews.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00D9FF),
                    ),
                  ),
                ],
              ),
            ),
            // Heatmap
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEDEDED),
                    ),
                  ),
                  const SizedBox(height: 16),
                  HeatMapCalendar(
                    defaultColor: const Color(0xFF2D2D2D),
                    textColor: const Color(0xFFEDEDED),
                    datasets: _heatmapData,
                    colorsets: const {
                      1: Color(0xFF1E5631),
                      2: Color(0xFF2A7F3C),
                      3: Color(0xFF40B055),
                      4: Color(0xFF5AC35C),
                      5: Color(0xFF6DD26D),
                      10: Color(0xFF00D9FF),
                      15: Color(0xFF00A8CC),
                      20: Color(0xFF006B9E),
                    },
                    onClick: (date) {
                      // Handle date click
                    },
                    fontSize: 11,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Stats overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard(
                    label: 'Retention',
                    value: '$_retention%',
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    label: 'Streak',
                    value: '$_streak days',
                    icon: Icons.local_fire_department,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    label: 'Reviews',
                    value: '${(_totalReviews / 100).toStringAsFixed(1)}k',
                    icon: Icons.auto_stories,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEDEDED),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    icon: Icons.cloud_sync,
                    label: 'Sync Now',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Syncing...')),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSettingsTile(
                    icon: Icons.download,
                    label: 'Export Data (CSV/JSON)',
                    onTap: () {
                      _showExportOptions();
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSettingsTile(
                    icon: Icons.tune,
                    label: 'Algorithm Settings (FSRS)',
                    onTap: () {
                      // TODO: Navigate to FSRS settings
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildSettingsTile(
                    icon: _darkMode ? Icons.dark_mode : Icons.light_mode,
                    label: _darkMode ? 'Dark Mode' : 'Light Mode',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Theme switching not implemented yet'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF00D9FF), size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEDEDED),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00D9FF), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFEDEDED),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Format',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEDEDED),
              ),
            ),
            const SizedBox(height: 16),
            _buildExportOption('CSV', Icons.table_chart),
            const SizedBox(height: 8),
            _buildExportOption('JSON', Icons.code),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Exporting as $label...')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF09090b),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2D2D2D)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00D9FF)),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFEDEDED),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
