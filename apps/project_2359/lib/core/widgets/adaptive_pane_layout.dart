import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdaptivePaneLayout extends StatelessWidget {
  final Widget master;
  final Widget? detail;
  final double masterWidth;
  final Widget? emptyDetail;
  final EdgeInsets? padding;

  const AdaptivePaneLayout({
    super.key,
    required this.master,
    this.detail,
    this.masterWidth = 350,
    this.emptyDetail,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    if (!isWide) {
      return Padding(padding: padding ?? EdgeInsets.zero, child: master);
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          SizedBox(width: masterWidth, child: master),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
          ),
          Expanded(child: detail ?? emptyDetail ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}
