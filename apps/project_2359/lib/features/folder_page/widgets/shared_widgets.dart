import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2359/core/widgets/sensor_reactive_border.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/source_page/source_page.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:provider/provider.dart';

class SectionLabel extends StatelessWidget {
  final String title;
  const SectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double width;
  final double? borderRadius;
  final Color? color;
  final List<Color>? borderColors;
  final bool hasSensorBorder;
  const HeaderAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.width = 48,
    this.borderRadius,
    this.color,
    this.borderColors,
    this.hasSensorBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final r = borderRadius ?? (width == 48 ? 24.0 : 16.0);

    Widget body = Container(
      width: width,
      height: 48,
      decoration: ShapeDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.05),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(r),
          side: hasSensorBorder
              ? BorderSide.none
              : BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
        ),
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: 16,
          color: color != null && color!.a > 0.5
              ? Colors.white
              : Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );

    if (hasSensorBorder) {
      body = SensorReactiveBorder(
        borderRadius: r,
        borderWidth: 1.5,
        colors: borderColors,
        // We use the theme background if the button is semi-transparent
        // to mask the gradient properly, then the Container above provides the tint.
        innerColor: color != null && color!.a < 0.9
            ? theme.scaffoldBackgroundColor
            : (color ?? cs.surface),
        child: body,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          body,
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.4),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class CompactIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CompactIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: FaIcon(icon, size: 16),
      color: Colors.white.withValues(alpha: 0.6),
    );
  }
}

class SelectionActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onPin;
  final VoidCallback onUnpin;
  final VoidCallback onDelete;
  final bool isUnpin;
  final bool isPinDisabled;

  const SelectionActionBar({
    super.key,
    required this.selectedCount,
    required this.onClose,
    required this.onPin,
    required this.onUnpin,
    required this.onDelete,
    this.isUnpin = false,
    this.isPinDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onClose,
            icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          Text(
            "$selectedCount Selected",
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          BarAction(
            icon: FontAwesomeIcons.thumbtack,
            label: isUnpin ? "Unpin" : "Pin",
            onTap: isUnpin ? onUnpin : onPin,
            isDisabled: isPinDisabled,
          ),
          const SizedBox(width: 8),
          BarAction(
            icon: FontAwesomeIcons.trashCan,
            label: "Delete",
            onTap: onDelete,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class BarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isDisabled;

  const BarAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDisabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
        : isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 14, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WizardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;

  const WizardButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (isSecondary) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? FaIcon(icon, size: 14) : null,
        label: Text(
          label,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: cs.onSurface.withValues(alpha: 0.1)),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon != null ? FaIcon(icon, size: 14) : null,
      label: Text(
        label,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class WizardSquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const WizardSquareButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.onSurface.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
          ),
          child: Center(child: FaIcon(icon, size: 18, color: cs.primary)),
        ),
      ),
    );
  }
}

class ImportToggleButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const ImportToggleButton({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: isActive ? cs.primary : cs.onSurface.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : cs.onSurface.withValues(alpha: 0.08),
            ),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              size: 18,
              color: isActive
                  ? Colors.white
                  : cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}

class WizardSourcePagePreview extends StatelessWidget {
  final String? sourceId;
  const WizardSourcePagePreview({super.key, this.sourceId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 48,
      height: 64,
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    height: 2,
                    width: double.infinity,
                    color: cs.onSurface.withValues(alpha: 0.05),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WizardFlashcardPreview extends StatelessWidget {
  const WizardFlashcardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 48,
      height: 64,
      child: Stack(
        children: [
          // Background card (shifted slightly)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 40,
              height: 54,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
              ),
            ),
          ),
          // Foreground card
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 40,
              height: 54,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.clone,
                  size: 14,
                  color: cs.primary.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SourcePageLoader extends StatefulWidget {
  final String sourceId;
  final String sourceLabel;
  final bool showBackButton;

  const SourcePageLoader({
    super.key,
    required this.sourceId,
    required this.sourceLabel,
    this.showBackButton = true,
  });

  @override
  State<SourcePageLoader> createState() => _SourcePageLoaderState();
}

class _SourcePageLoaderState extends State<SourcePageLoader> {
  SourceItemBlob? _blob;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBlob();
  }

  Future<void> _loadBlob() async {
    final sourceService = SourceService(context.read<AppDatabase>());
    final blob = await sourceService.getSourceBlobBySourceId(widget.sourceId);
    if (mounted) {
      setState(() {
        _blob = blob;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_blob == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("File data not found")),
      );
    }

    return SourcePage(
      fileBytes: _blob!.bytes,
      title: widget.sourceLabel,
      showBackButton: widget.showBackButton,
    );
  }
}
