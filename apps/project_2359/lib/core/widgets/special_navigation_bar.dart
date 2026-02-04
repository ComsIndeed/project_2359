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

class SpecialNavigationBar extends StatefulWidget {
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
  State<SpecialNavigationBar> createState() => _SpecialNavigationBarState();
}

class _SpecialNavigationBarState extends State<SpecialNavigationBar> {
  Widget? _activeActions;

  @override
  Widget build(BuildContext context) {
    final activeItem = widget.items[widget.currentIndex];
    final hasActions = activeItem.pageActions != null;

    // Persist the last set of actions so they don't disappear instantly during animation
    if (hasActions) {
      _activeActions = activeItem.pageActions;
    }

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
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            height: hasActions ? 115 : 60,
            width: double.infinity,
          ),

          // Page Actions Popup
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: hasActions ? Curves.easeOutBack : Curves.easeInCubic,
            bottom: hasActions ? 72 : 30, // Tighter transition
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: hasActions ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !hasActions,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: AppTheme.secondarySurface.withValues(alpha: 0.9),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Theme(
                      data: AppTheme.darkTheme.copyWith(
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: IntrinsicHeight(
                          child: AnimatedScale(
                            scale: hasActions ? 1.0 : 0.6,
                            duration: const Duration(milliseconds: 350),
                            curve: hasActions
                                ? Curves.easeOutBack
                                : Curves.easeInBack,
                            alignment: Alignment.bottomCenter,
                            child: _activeActions ?? const SizedBox.shrink(),
                          ),
                        ),
                      ),
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
                width: 130.0 * widget.items.length,
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
                        -1.0 +
                            (widget.currentIndex *
                                (2.0 / (widget.items.length - 1))),
                        0,
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 1 / widget.items.length,
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
                      children: List.generate(widget.items.length, (index) {
                        final item = widget.items[index];
                        final isSelected = widget.currentIndex == index;
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
            onTap: () => widget.onTap(index),
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
