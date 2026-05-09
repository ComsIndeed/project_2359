import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdaptivePaneLayout extends StatelessWidget {
  final Widget master;
  final Widget? detail;
  final double masterWidth;
  final Widget? emptyDetail;
  final EdgeInsets? padding;
  final bool isNested;
  final bool wrapDetail;

  const AdaptivePaneLayout({
    super.key,
    required this.master,
    this.detail,
    this.masterWidth = 350,
    this.emptyDetail,
    this.padding,
    this.isNested = false,
    this.wrapDetail = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;
    if (!isWide) {
      return Padding(padding: padding ?? EdgeInsets.zero, child: master);
    }

    final outerPadding = isNested ? EdgeInsets.zero : (padding ?? const EdgeInsets.all(12));
    final panelSpacing = 12.0;
    
    final panelDecoration = ShapeDecoration(
      color: theme.colorScheme.surface,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.08,
          ),
          width: 1.2,
        ),
      ),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );

    return Padding(
      padding: outerPadding,
      child: Row(
        children: [
          // Master Panel
          SizedBox(
            width: masterWidth,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: panelDecoration,
              child: master,
            ),
          ),
          
          SizedBox(width: panelSpacing),
          
          // Detail Panel
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutQuart,
              switchOutCurve: Curves.easeInQuart,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: detail != null
                  ? (!wrapDetail
                      ? SizedBox.expand(key: ValueKey(detail.hashCode), child: detail!)
                      : Container(
                          key: ValueKey(detail.hashCode),
                          clipBehavior: Clip.antiAlias,
                          decoration: panelDecoration,
                          child: detail,
                        ))
                  : (emptyDetail != null
                      ? Container(
                          key: ValueKey('empty_detail'),
                          clipBehavior: Clip.antiAlias,
                          decoration: panelDecoration,
                          child: emptyDetail,
                        )
                      : const SizedBox.shrink(key: ValueKey('none'))),
            ),
          ),
        ],
      ),
    );
  }
}
