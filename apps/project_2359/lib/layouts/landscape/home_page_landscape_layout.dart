import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePageLandscapeLayout extends StatefulWidget {
  final Widget sidebarA;
  final Widget? sidebarB;
  final Widget mainContent;
  final Widget header;
  final VoidCallback onSettingsTap;
  final VoidCallback onProfileTap;

  const HomePageLandscapeLayout({
    super.key,
    required this.sidebarA,
    this.sidebarB,
    required this.mainContent,
    required this.header,
    required this.onSettingsTap,
    required this.onProfileTap,
  });

  @override
  State<HomePageLandscapeLayout> createState() =>
      _HomePageLandscapeLayoutState();
}

class _HomePageLandscapeLayoutState extends State<HomePageLandscapeLayout> {
  bool _isCollapsed = false;

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        // Sidebar A: Collections
        AnimatedContainer(
          duration: 300.ms,
          curve: Curves.easeOutCubic,
          width: _isCollapsed ? 80 : 280,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
            ),
          ),
          child: Column(
            children: [
              // Header
              if (!_isCollapsed)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: widget.header,
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: FaIcon(
                    FontAwesomeIcons.solidMoon,
                    size: 24,
                  ), // Placeholder for logo
                ),

              // Sidebar A Content
              Expanded(
                child: ClipRect(
                  child: AnimatedOpacity(
                    duration: 200.ms,
                    opacity: _isCollapsed ? 0 : 1,
                    child: _isCollapsed
                        ? const SizedBox.shrink()
                        : widget.sidebarA,
                  ),
                ),
              ),

              // Bottom Actions
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: _isCollapsed ? 0 : 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: cs.onSurface.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: _isCollapsed
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _IconButton(
                            icon: FontAwesomeIcons.solidUser,
                            onTap: widget.onProfileTap,
                            isCollapsed: true,
                          ),
                          const SizedBox(height: 12),
                          _IconButton(
                            icon: FontAwesomeIcons.gear,
                            onTap: widget.onSettingsTap,
                            isCollapsed: true,
                          ),
                          const SizedBox(height: 12),
                          _IconButton(
                            icon: FontAwesomeIcons.chevronRight,
                            onTap: _toggleCollapse,
                            isCollapsed: true,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          _IconButton(
                            icon: FontAwesomeIcons.solidUser,
                            onTap: widget.onProfileTap,
                          ),
                          const SizedBox(width: 8),
                          _IconButton(
                            icon: FontAwesomeIcons.gear,
                            onTap: widget.onSettingsTap,
                          ),
                          const Spacer(),
                          _IconButton(
                            icon: FontAwesomeIcons.chevronLeft,
                            onTap: _toggleCollapse,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),

        // Sidebar B: Folder Contents
        if (widget.sidebarB != null)
          AnimatedContainer(
            duration: 300.ms,
            curve: Curves.easeOutCubic,
            width: 320,
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withValues(alpha: 0.3),
              border: Border(
                right: BorderSide(color: cs.onSurface.withValues(alpha: 0.1)),
              ),
            ),
            child: widget.sidebarB,
          ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.05, end: 0),

        // Main Content
        Expanded(child: widget.mainContent),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isCollapsed;

  const _IconButton({
    required this.icon,
    required this.onTap,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onTap,
      icon: FaIcon(
        icon,
        size: isCollapsed ? 18 : 20,
        color: cs.onSurface.withValues(alpha: 0.6),
      ),
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: cs.onSurface.withValues(alpha: 0.05),
      ),
    );
  }
}
