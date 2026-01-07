import 'package:flutter/material.dart';
import 'home/homepage.dart';
import 'materials/materials_page.dart';
import 'sources/sources_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const MaterialsPage(),
    const Center(
      child: Text('Study Session', style: TextStyle(color: Colors.white)),
    ),
    const SourcesPage(),
    const Center(
      child: Text('Profile', style: TextStyle(color: Colors.white)),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E14).withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Home'),
              _buildNavItem(1, Icons.folder_rounded, 'Materials'),
              const SizedBox(width: 60), // Space for the center button
              _buildNavItem(3, Icons.library_books_rounded, 'Sources'),
              _buildNavItem(4, Icons.person_rounded, 'Profile'),
            ],
          ),
          Positioned(
            top: -20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onItemTapped(2),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7DFF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7DFF).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF0B0E14),
                      width: 4,
                    ),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _selectedIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF2E7DFF) : Colors.white24,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? const Color(0xFF2E7DFF) : Colors.white24,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
