import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class SpecialNavigationItem {
  final IconData icon;
  final String label;

  const SpecialNavigationItem({required this.icon, required this.label});
}

class SpecialNavigationBar extends StatelessWidget {
  final List<SpecialNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SpecialNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 130.0 * items.length, // Dynamic width based on item count
            height: 60,
            padding: const EdgeInsets.all(6),
            decoration: ShapeDecoration(
              color: AppTheme.surface.withValues(alpha: 0.95),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Sliding Pill Background
                AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment(
                    -1.0 + (currentIndex * (2.0 / (items.length - 1))),
                    0,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / items.length,
                    heightFactor: 1,
                    child: Container(
                      decoration: ShapeDecoration(
                        color: AppTheme.primary.withValues(
                          alpha: 0.5,
                        ), // Lowkey pill
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                // Navigation Items
                Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = currentIndex == index;
                    return Expanded(
                      child: _buildNavItem(
                        index,
                        item.icon,
                        item.label,
                        isSelected,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    final navShape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(18),
    );

    return RepaintBoundary(
      child: AnimatedScale(
        scale: isSelected ? 1.175 : 1.0, // Emphasized growth
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutBack,
        child: InkWell(
          onTap: () => onTap(index),
          customBorder: navShape,
          splashColor: AppTheme.primary.withValues(alpha: 0.2),
          highlightColor: Colors.transparent,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
