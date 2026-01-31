import 'package:flutter/material.dart';
import 'package:project_2359/app_theme.dart';

class SpecialSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const SpecialSearchBar({
    super.key,
    this.hintText = "Search...",
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      barHintText: 'Search',
      suggestionsBuilder: (_, searchController) => [],
    );
  }
}
