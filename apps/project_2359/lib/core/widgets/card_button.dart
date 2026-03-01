import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/pressable_scale.dart';
import 'package:project_2359/core/widgets/special_background_generator.dart';

/// The layout direction for a [CardButton]
enum CardLayoutDirection {
  /// Icon on top, text below (default)
  vertical,

  /// Icon on the left, text on the right
  horizontal,
}

enum _SeedSource { manual, label, icon, sublabel }

class GenerationSeed {
  final String? _value;
  final _SeedSource _source;

  const GenerationSeed._(this._value, this._source);

  factory GenerationSeed.fromString(String value) {
    return GenerationSeed._(value, _SeedSource.manual);
  }

  static const GenerationSeed label = GenerationSeed._(null, _SeedSource.label);
  static const GenerationSeed icon = GenerationSeed._(null, _SeedSource.icon);
  static const GenerationSeed sublabel = GenerationSeed._(
    null,
    _SeedSource.sublabel,
  );

  factory GenerationSeed.useLabel() => label;
  factory GenerationSeed.useIcon() => icon;
  factory GenerationSeed.useSublabel() => sublabel;

  String resolve(String label, IconData icon, String? subLabel) {
    switch (_source) {
      case _SeedSource.manual:
        return _value!;
      case _SeedSource.label:
        return label;
      case _SeedSource.icon:
        return icon.codePoint.toString();
      case _SeedSource.sublabel:
        return subLabel ?? label; // Fallback to label if sublabel is null
    }
  }
}

class CardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final GenerationSeed? backgroundGenerator;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final CardButtonStyle? style;
  final CardLayoutDirection layoutDirection;
  final EdgeInsetsGeometry? padding;
  final double? labelFontSize;
  final double? subLabelFontSize;
  final TextStyle? labelStyle;
  final TextStyle? subLabelStyle;
  final bool isCompact;
  final Color? accentColor;
  final GenerationSeed? iconColorGenerator;
  final Widget? trailing;
  final SpecialBackgroundType backgroundType;

  const CardButton({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    this.backgroundGenerator,
    this.onTap,
    this.onLongPress,
    this.style,
    this.layoutDirection = CardLayoutDirection.vertical,
    this.padding,
    this.labelFontSize,
    this.subLabelFontSize,
    this.labelStyle,
    this.subLabelStyle,
    this.isCompact = false,
    this.accentColor,
    this.iconColorGenerator,
    this.trailing,
    this.backgroundType = SpecialBackgroundType.vibrantGradients,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasBackground = backgroundGenerator != null;
    final bool isDisabled = onTap == null && onLongPress == null;

    // Content widget (shared between both paths)
    final contentWidget = Padding(
      padding:
          padding ??
          (isCompact ? const EdgeInsets.all(12.0) : const EdgeInsets.all(16.0)),
      child: layoutDirection == CardLayoutDirection.horizontal
          ? _buildHorizontalContent(context)
          : _buildVerticalContent(context),
    );

    final cs = Theme.of(context).colorScheme;
    final effectiveSeed =
        backgroundGenerator ?? GenerationSeed.fromString("idle");

    return PressableScale(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: cs.surface.withValues(alpha: hasBackground ? 0.0 : 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                (hasBackground
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.08))
                    .withValues(alpha: isDisabled ? 0.04 : null),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background Layer
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: hasBackground ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: SpecialBackgroundGenerator(
                    seed: effectiveSeed,
                    label: label,
                    icon: icon,
                    subLabel: subLabel,
                    style: style,
                    isDisabled: isDisabled,
                    type: backgroundType,
                    showBorder: false,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              // Content Layer
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  customBorder: AppTheme.cardShape,
                  child: Opacity(
                    opacity: isDisabled ? 0.4 : 1.0,
                    child: contentWidget,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context) {
    final double iconSize = isCompact ? 28 : 34; // Slightly larger icons

    Color? generatedColor;
    if (iconColorGenerator != null) {
      generatedColor = SpecialBackgroundUtils.iconColor(
        seed: iconColorGenerator!,
        label: label,
        icon: icon,
        subLabel: subLabel,
      );
    }

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasBg = backgroundGenerator != null;
    final Color defaultContentColor = (hasBg && !isDark)
        ? Theme.of(context).colorScheme.primary
        : Colors.white;

    final Color effectiveIconColor =
        accentColor ?? generatedColor ?? defaultContentColor;

    return Container(
      padding: EdgeInsets.zero, // Removed padding and decoration
      child: FaIcon(icon, color: effectiveIconColor, size: iconSize),
    );
  }

  Widget _buildVerticalContent(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasBg = backgroundGenerator != null;
    final Color? adaptiveColor = (hasBg && !isDark)
        ? Theme.of(context).colorScheme.onSurface
        : null;

    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final effectiveLabelStyle = (labelStyle ?? cardStyle.labelStyle)?.copyWith(
      fontSize: labelFontSize,
      color: labelStyle?.color ?? adaptiveColor ?? cardStyle.labelStyle?.color,
    );
    final effectiveSubLabelStyle = (subLabelStyle ?? cardStyle.subLabelStyle)
        ?.copyWith(
          fontSize: subLabelFontSize,
          color:
              subLabelStyle?.color ??
              (adaptiveColor?.withValues(alpha: 0.65)) ??
              cardStyle.subLabelStyle?.color,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconContainer(context),
        const SizedBox(height: 16),
        Text(
          label,
          style: effectiveLabelStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subLabel != null) ...[
          const SizedBox(height: 4),
          Text(
            subLabel!,
            style: effectiveSubLabelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (trailing != null) ...[const SizedBox(height: 8), trailing!],
      ],
    );
  }

  Widget _buildHorizontalContent(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasBg = backgroundGenerator != null;
    final Color? adaptiveColor = (hasBg && !isDark)
        ? Theme.of(context).colorScheme.onSurface
        : null;

    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final effectiveLabelStyle = (labelStyle ?? cardStyle.labelStyle)?.copyWith(
      fontSize: labelFontSize,
      color: labelStyle?.color ?? adaptiveColor ?? cardStyle.labelStyle?.color,
    );
    final effectiveSubLabelStyle = (subLabelStyle ?? cardStyle.subLabelStyle)
        ?.copyWith(
          fontSize: subLabelFontSize,
          color:
              subLabelStyle?.color ??
              (adaptiveColor?.withValues(alpha: 0.65)) ??
              cardStyle.subLabelStyle?.color,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildIconContainer(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: effectiveLabelStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subLabel!,
                      style: effectiveSubLabelStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ],
    );
  }
}
