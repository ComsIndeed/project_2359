import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/core.dart';
import '../common/project_image.dart';
import '../common/app_list_tile.dart';
import '../common/app_header.dart';

import 'sources_providers.dart';

class SourcesPage extends ConsumerStatefulWidget {
  const SourcesPage({super.key});

  @override
  ConsumerState<SourcesPage> createState() => _SourcesPageState();
}

class _SourcesPageState extends ConsumerState<SourcesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final recentSourcesAsync = ref.watch(recentSourcesProvider);
    final filteredSourcesAsync = ref.watch(filteredSourcesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                AppPageHeader(
                  title: 'My Sources',
                  subtitle: 'PROJECT 2359',
                  icon: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.library_books,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSearchBar(context),
                const SizedBox(height: 20),
                _buildCategories(context, selectedCategory),
                const SizedBox(height: 32),
                AppSectionHeader(
                  title: 'Recent',
                  actionLabel: 'View All',
                  onActionTap: () {},
                ),
                const SizedBox(height: 16),
                recentSourcesAsync.when(
                  data: (sources) => _buildRecentList(context, sources),
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text('Error: $e'),
                ),
                const SizedBox(height: 32),
                const AppSectionHeader(title: 'All Materials'),
                const SizedBox(height: 16),
                filteredSourcesAsync.when(
                  data: (sources) => _buildMaterialsList(context, sources),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
          hintText: 'Search notes, PDFs, links...',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          ref.read(sourceSearchQueryProvider.notifier).setQuery(value);
        },
      ),
    );
  }

  Widget _buildCategories(BuildContext context, SourceType? selectedCategory) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sourceCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = sourceCategories[index];
          final isSelected = selectedCategory == category.type;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref
                    .read(selectedCategoryProvider.notifier)
                    .select(category.type);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      category.icon,
                      color: isSelected ? Colors.white : Colors.white54,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentList(BuildContext context, List<Source> sources) {
    if (sources.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No recent sources',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sources.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final source = sources[index];
          return Container(
            width: 240,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Mark as accessed and navigate
                  ref
                      .read(sourcesDatasourceProvider)
                      .markSourceAccessed(source.id);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          if (source.thumbnailPath != null)
                            ProjectImage(
                              imageUrl: source.thumbnailPath!,
                              width: double.infinity,
                            ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: source.typeColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                source.type.name.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              source.title,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              source.metadata,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMaterialsList(BuildContext context, List<Source> materials) {
    if (materials.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No materials found',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: materials
          .map((material) => _buildMaterialItem(context, material))
          .toList(),
    );
  }

  Widget _buildMaterialItem(BuildContext context, Source material) {
    return AppListTile(
      title: material.title,
      subtitle: material.metadata,
      icon: material.icon,
      iconColor: material.typeColor,
      onTap: () {
        ref.read(sourcesDatasourceProvider).markSourceAccessed(material.id);
      },
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
      ),
    );
  }
}
