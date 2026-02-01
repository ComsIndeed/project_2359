import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/special_search_bar.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sources",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SpecialSearchBar(),
              SizedBox(height: 8),
              Container(
                height: 32,
                decoration: ShapeDecoration(
                  shape: AppTheme.buttonShape,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.upload,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: Text(
                        "Import",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      width: 8,
                      indent: 8,
                      endIndent: 8,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Generate",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
