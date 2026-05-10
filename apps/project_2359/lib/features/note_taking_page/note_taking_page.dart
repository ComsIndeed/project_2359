import 'package:flutter/material.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
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
  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('New Note')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Note Taking Content Goes Here')],
        ),
      ),
    );
  }
}
