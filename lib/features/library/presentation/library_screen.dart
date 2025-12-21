import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:project_2359/features/library/presentation/widgets/deck_tile.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data for decks
  final List<Map<String, dynamic>> _decks = [
    {'title': 'Spanish Vocabulary', 'dueCount': 15},
    {'title': 'Biology Fundamentals', 'dueCount': 8},
    {'title': 'Python Basics', 'dueCount': 0},
    {'title': 'World History', 'dueCount': 23},
    {'title': 'French Grammar', 'dueCount': 5},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddModal() {
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
          children: [
            Text(
              'Create New',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEDEDED),
              ),
            ),
            const SizedBox(height: 24),
            _ModalOption(
              icon: Icons.note_add,
              label: 'New Deck',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to create deck screen
              },
            ),
            const SizedBox(height: 12),
            _ModalOption(
              icon: Icons.upload_file,
              label: 'Upload PDF',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to PDF upload
              },
            ),
            const SizedBox(height: 12),
            _ModalOption(
              icon: Icons.add_card,
              label: 'Add Card',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to create card screen
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddModal,
        backgroundColor: const Color(0xFF00D9FF),
        foregroundColor: const Color(0xFF09090b),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Library',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEDEDED),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.inter(color: const Color(0xFFEDEDED)),
                      decoration: InputDecoration(
                        hintText: 'Search decks...',
                        hintStyle: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                        ),
                        prefixIcon: const Icon(
                          LucideIcons.search,
                          color: Color(0xFF6B7280),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Decks list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final deck = _decks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: DeckTile(
                  title: deck['title'],
                  dueCount: deck['dueCount'],
                  onTap: () {
                    // TODO: Navigate to deck detail
                  },
                ),
              );
            }, childCount: _decks.length),
          ),
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _ModalOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ModalOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
