import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/expandable_container.dart';

class CardCreationPage extends StatefulWidget {
  final String folderId;
  const CardCreationPage({super.key, required this.folderId});

  @override
  State<CardCreationPage> createState() => _CardCreationPageState();
}

class _CardCreationPageState extends State<CardCreationPage> {
  ExpandableContainerMode _mode = ExpandableContainerMode.dynamic;

  double _freeformHeightFactor = 0.45;
  final double _freeformWidthFactor = 0.35;

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isMobile = breakpoints.isMobile || breakpoints.isPhone;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: ExpandableContainer(
        mode: _mode,
        isLandscape: isLandscape && !isMobile,
        freeformHeightFactor: _freeformHeightFactor,
        freeformWidthFactor: _freeformWidthFactor,
        onCollapse: () =>
            setState(() => _mode = ExpandableContainerMode.collapsed),
        onExpand: () => setState(() => _mode = ExpandableContainerMode.dynamic),
        body: _buildMainContent(),
        collapsedChild: _buildDock(isVertical: isLandscape && !isMobile),
        expandedChild: _buildToolsContent(isLandscape && !isMobile),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Card Creation (${widget.folderId})',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _mode == ExpandableContainerMode.fullscreen
                ? Icons.fullscreen_exit
                : Icons.fullscreen,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (_mode == ExpandableContainerMode.fullscreen) {
                _mode = ExpandableContainerMode.dynamic;
              } else {
                _mode = ExpandableContainerMode.fullscreen;
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.save_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade900, Colors.purple.shade900, Colors.black],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 64, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'Main Preview Area',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildToolsContent(bool isVertical) {
    return Column(
      children: [
        if (!isVertical) _buildGrabber(),
        if (isVertical) const SizedBox(height: 64), // Space from top if sidebar
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isVertical ? 'Tool Sidebar' : 'Content Tools',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: Icon(
                  isVertical ? Icons.chevron_right : Icons.keyboard_arrow_down,
                ),
                onPressed: () =>
                    setState(() => _mode = ExpandableContainerMode.collapsed),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 15,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(
                _getToolIcon(index),
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Creation Tool Item $index'),
              subtitle: Text('Modify element $index'),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }

  IconData _getToolIcon(int index) {
    switch (index % 4) {
      case 0:
        return Icons.text_fields;
      case 1:
        return Icons.palette;
      case 2:
        return Icons.image;
      case 3:
        return Icons.animation;
      default:
        return Icons.edit;
    }
  }

  Widget _buildDock({required bool isVertical}) {
    return InkWell(
      onTap: () => setState(() => _mode = ExpandableContainerMode.dynamic),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: isVertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.auto_awesome_motion,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () =>
                        setState(() => _mode = ExpandableContainerMode.dynamic),
                  ),
                  const SizedBox(height: 12),
                  const Icon(Icons.palette, color: Colors.white70),
                  const SizedBox(height: 12),
                  const Icon(Icons.text_fields, color: Colors.white70),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.auto_awesome_motion,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () =>
                        setState(() => _mode = ExpandableContainerMode.dynamic),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.palette, color: Colors.white70),
                  const SizedBox(width: 16),
                  const Icon(Icons.text_fields, color: Colors.white70),
                  const SizedBox(width: 16),
                  const Icon(Icons.image_search, color: Colors.white70),
                ],
              ),
      ),
    );
  }

  Widget _buildGrabber() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _mode = ExpandableContainerMode.freeform;
          _freeformHeightFactor -=
              details.delta.dy / MediaQuery.of(context).size.height;
          _freeformHeightFactor = _freeformHeightFactor.clamp(0.2, 0.9);
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
