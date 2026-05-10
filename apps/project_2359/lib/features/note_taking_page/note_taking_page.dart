import 'package:flutter/material.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
import 'package:project_2359/core/widgets/adaptive_pane_layout.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NoteTakingPage extends StatefulWidget {
  final String collectionId;
  final String? deckId;
  final String? draftId;

  const NoteTakingPage({
    super.key,
    required this.collectionId,
    this.deckId,
    this.draftId,
  });

  @override
  State<NoteTakingPage> createState() => _NoteTakingPageState();
}

class _NoteTakingPageState extends State<NoteTakingPage> {
  int _selectedTabIndex = 0;
  late PageController _pageController;
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleBar();
    });
  }

  void _updateTitleBar() {
    if (!mounted) return;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    if (!isDesktop) return;

    final titleBar = context.read<DesktopTitleBarController>();
    titleBar.setCenteredTitle('Taking Notes');
    titleBar.setHideBack(false);
    titleBar.setOnBack(() {
      titleBar.reset();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Reset title bar when leaving the page
    Future.microtask(() {
      if (mounted) {
        context.read<DesktopTitleBarController>().reset();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    if (isDesktop) {
      return _buildDesktopLayout(context);
    }

    return _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final masterWidth = _isMaximized ? screenWidth * 0.8 : screenWidth * 0.25;

    return Scaffold(
      body: AdaptivePaneLayout(
        masterWidth: masterWidth,
        master: (context, controller) => _buildSidePanel(context, controller, isCollapsed: false),
        masterCollapsed: (context, controller) => _buildSidePanel(context, controller, isCollapsed: true),
        detail: (context, controller) => _buildMainContent(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: Stack(
        children: [
          _buildMainContent(context),
          _buildDraggableBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildSidePanel(BuildContext context, AdaptivePaneController controller, {required bool isCollapsed}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              if (!isCollapsed)
                Expanded(
                  child: _buildTabSwitcher(),
                ),
              if (!isCollapsed) const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isCollapsed)
                    IconButton(
                      onPressed: () => setState(() => _isMaximized = !_isMaximized),
                      icon: Icon(_isMaximized ? Icons.fullscreen_exit : Icons.fullscreen),
                      tooltip: _isMaximized ? 'Restore' : 'Maximize',
                    ),
                  IconButton(
                    onPressed: controller.toggleCollapsed,
                    icon: Icon(isCollapsed ? Icons.menu : Icons.menu_open),
                    tooltip: isCollapsed ? 'Expand' : 'Collapse',
                  ),
                ],
              ),
            ],
          ),
          if (!isCollapsed) ...[
            const SizedBox(height: 24),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _selectedTabIndex = index),
                children: [
                  _buildTabContent('Notes Content'),
                  _buildTabContent('Sources Content'),
                  _buildTabContent('Draft Content'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    final theme = Theme.of(context);
    final tabs = ['Notes', 'Sources', 'Draft'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            alignment: Alignment(-1.0 + (_selectedTabIndex * 1.0), 0),
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Row(
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isSelected = _selectedTabIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedTabIndex = index);
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuart,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String placeholder) {
    return Center(
      child: Text(
        placeholder,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return const SizedBox.expand();
  }

  Widget _buildDraggableBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: ShapeDecoration(
            color: theme.colorScheme.surface,
            shape: RoundedSuperellipseBorder(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              side: BorderSide(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Note Details',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
