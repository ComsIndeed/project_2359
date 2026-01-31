import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class SpecialNavigationItem {
  final IconData icon;
  final String label;
  final Widget? pageActions;

  const SpecialNavigationItem({
    required this.icon,
    required this.label,
    this.pageActions,
  });
}

// TODO: Add ripples to the popup buttons

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
    final activeItem = items[currentIndex];
    final hasActions = activeItem.pageActions != null;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.only(
        bottom: hasActions
            ? 16
            : 32, // Moves navbar down slightly when actions shown
        left: 24,
        right: 24,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Page Actions Popup
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: hasActions ? Curves.easeOutBack : Curves.easeInCubic,
            bottom: hasActions ? 72 : 20, // Slides up from behind the bar
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: hasActions ? 1.0 : 0.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: MediaQuery.of(context).size.width - 80,
                ),
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.transparent, // Background handled by Material
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: AppTheme.surface.withValues(alpha: 0.98),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: activeItem.pageActions ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Navigation Bar Container
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130.0 * items.length,
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
                    // Sliding active tab background
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
                            color: AppTheme.primary.withValues(alpha: 0.5),
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
        scale: isSelected ? 1.175 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutBack,
        child: Material(
          type: MaterialType.transparency,
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
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
