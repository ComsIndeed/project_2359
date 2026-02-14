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

  const CardButton({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    this.backgroundGenerator,
    this.onTap,
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
  });

  @override
  Widget build(BuildContext context) {
    final bool hasBackground = backgroundGenerator != null;
    final bool isDisabled = onTap == null;

    // Content widget (shared between both paths)
    final contentWidget = Padding(
      padding:
          padding ??
          (isCompact ? const EdgeInsets.all(12.0) : const EdgeInsets.all(16.0)),
      child: layoutDirection == CardLayoutDirection.horizontal
          ? _buildHorizontalContent(context)
          : _buildVerticalContent(context),
    );

    // Inner child: opacity + InkWell
    Widget innerChild = Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: contentWidget,
    );

    // Wrap with the generated background or a plain surface container
    Widget body;
    if (hasBackground) {
      body = SpecialBackgroundGenerator(
        seed: backgroundGenerator!,
        label: label,
        icon: icon,
        subLabel: subLabel,
        style: style,
        isDisabled: isDisabled,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: AppTheme.cardShape,
            child: innerChild,
          ),
        ),
      );
    } else {
      final plainDecoration = BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      );

      body = Container(
        decoration: plainDecoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: AppTheme.cardShape,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: innerChild,
            ),
          ),
        ),
      );
    }

    return PressableScale(onTap: onTap, child: body);
  }

  Widget _buildIconContainer() {
    final double iconSize = isCompact ? 22 : 28;
    final double containerPadding = isCompact ? 8 : 10;

    Color? generatedColor;
    if (iconColorGenerator != null) {
      generatedColor = SpecialBackgroundUtils.iconColor(
        seed: iconColorGenerator!,
        label: label,
        icon: icon,
        subLabel: subLabel,
      );
    }

    final Color effectiveIconColor =
        accentColor ?? generatedColor ?? Colors.white;

    // Calculate bg/border based on the effective color
    final Color backgroundColor = effectiveIconColor == Colors.white
        ? Colors.white.withValues(alpha: 0.12)
        : effectiveIconColor.withValues(alpha: 0.15);

    final Color borderColor = effectiveIconColor == Colors.white
        ? Colors.white.withValues(alpha: 0.25)
        : effectiveIconColor.withValues(alpha: 0.25);

    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: FaIcon(icon, color: effectiveIconColor, size: iconSize),
    );
  }

  Widget _buildVerticalContent(BuildContext context) {
    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final effectiveLabelStyle = (labelStyle ?? cardStyle.labelStyle)?.copyWith(
      fontSize: labelFontSize,
    );
    final effectiveSubLabelStyle = (subLabelStyle ?? cardStyle.subLabelStyle)
        ?.copyWith(fontSize: subLabelFontSize);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconContainer(),
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
      ],
    );
  }

  Widget _buildHorizontalContent(BuildContext context) {
    final cardStyle = style ?? AppTheme.cardButtonStyle;
    final effectiveLabelStyle = (labelStyle ?? cardStyle.labelStyle)?.copyWith(
      fontSize: labelFontSize,
    );
    final effectiveSubLabelStyle = (subLabelStyle ?? cardStyle.subLabelStyle)
        ?.copyWith(fontSize: subLabelFontSize);

    return Row(
      children: [
        _buildIconContainer(),
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
      ],
    );
  }
}
