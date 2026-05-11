import 'package:flutter/material.dart';
import 'package:project_2359/core/widgets/adaptive_pane_layout.dart';
import 'package:project_2359/core/widgets/desktop_title_bar_controller.dart';
import 'package:project_2359/core/widgets/project_back_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String? _selectedHelpTopic;

  final List<Map<String, String>> _topics = [
    {
      'title': 'Getting Started',
      'content': 'Welcome to project_2359! This app helps you take notes from PDFs and create flashcards automatically.',
    },
    {
      'title': 'Note Types',
      'content': 'We support Basic, Reversed, Cloze, and Image Occlusion cards. Each serves a different purpose for learning.',
    },
    {
      'title': 'PDF Viewer',
      'content': 'You can select text in the PDF to create notes. Use the dark mode toggle to invert colors for easier reading.',
    },
    {
      'title': 'Keyboard Shortcuts',
      'content': 'Ctrl+N for new note, Ctrl+S to save, Ctrl+F to search.',
    },
  ];

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
    titleBar.setCenteredTitle('Help & Documentation');
    titleBar.setHideBack(false);
    titleBar.setOnBack(() {
      titleBar.reset();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    if (isDesktop) {
      return Scaffold(
        body: AdaptivePaneLayout(
          masterWidth: 300,
          master: (context, controller) => _buildSidebar(isMobile: false),
          detail: (context, controller) => _buildDetailContent(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        leading: const ProjectBackButton(),
      ),
      body: _buildSidebar(isMobile: true),
    );
  }

  Widget _buildSidebar({required bool isMobile}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _topics.length,
      itemBuilder: (context, index) {
        final topic = _topics[index];
        final isSelected = _selectedHelpTopic == topic['title'];

        return ListTile(
          title: Text(topic['title']!),
          selected: !isMobile && isSelected,
          trailing: isMobile ? const Icon(Icons.chevron_right) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: () {
            if (isMobile) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: Text(topic['title']!)),
                    body: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(topic['content']!),
                    ),
                  ),
                ),
              );
            } else {
              setState(() => _selectedHelpTopic = topic['title']);
            }
          },
        );
      },
    );
  }

  Widget _buildDetailContent() {
    if (_selectedHelpTopic == null) {
      return const Center(
        child: Text('Select a topic to view details'),
      );
    }

    final topic = _topics.firstWhere((t) => t['title'] == _selectedHelpTopic);

    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic['title']!,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            topic['content']!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
