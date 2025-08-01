import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/linux_discovery_service.dart';
import 'package:myapp/data/macos_discovery_service.dart';
import 'package:myapp/domain/sort_criteria.dart';
import 'package:myapp/models/app_entity.dart';
import 'package:myapp/presentation/app_list_view.dart';
import 'package:myapp/presentation/providers.dart';
import 'package:myapp/presentation/widgets/empty_state.dart';

final appListProvider = StateProvider<List<AppEntity>>((ref) => []);
final isLoadingProvider = StateProvider<bool>((ref) => false);
final sortCriteriaProvider = StateProvider<SortCriteria>(
    (ref) => SortCriteria(field: SortField.name, direction: SortDirection.ascending));
final filterProvider = StateProvider<String>((ref) => '');

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appList = ref.watch(appListProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final sortCriteria = ref.watch(sortCriteriaProvider);
    final filter = ref.watch(filterProvider);

    final filteredAppList = _filterApps(appList, filter);
    final sortedAppList = _sortApps(filteredAppList, sortCriteria);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AppManager',
          style: GoogleFonts.sora(fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildSortMenu(ref),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: AppSearchDelegate(ref),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            tooltip: 'Clear Cache & Rescan',
            onPressed: () async {
              ref.read(isLoadingProvider.notifier).state = true;
              final discoveryService =
                  ref.read(applicationDiscoveryServiceProvider);
              if (Platform.isMacOS) {
                await (discoveryService as MacOSDiscoveryService).clear();
              } else if (Platform.isLinux) {
                await (discoveryService as LinuxDiscoveryService).clear();
              }
              final apps = await discoveryService.discoverApplications();
              ref.read(appListProvider.notifier).state = apps;
              ref.read(isLoadingProvider.notifier).state = false;
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              ref.read(isLoadingProvider.notifier).state = true;
              final apps = await ref
                  .read(applicationDiscoveryServiceProvider)
                  .discoverApplications();
              ref.read(appListProvider.notifier).state = apps;
              ref.read(isLoadingProvider.notifier).state = false;
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sortedAppList.isEmpty
              ? const EmptyState()
              : AppListView(apps: sortedAppList),
    );
  }

  Widget _buildSortMenu(WidgetRef ref) {
    final sortCriteria = ref.watch(sortCriteriaProvider);
    return PopupMenuButton<SortField>(
      onSelected: (SortField field) {
        final currentDirection = sortCriteria.direction;
        final newDirection = sortCriteria.field == field
            ? (currentDirection == SortDirection.ascending
                ? SortDirection.descending
                : SortDirection.ascending)
            : SortDirection.ascending;
        ref.read(sortCriteriaProvider.notifier).state =
            SortCriteria(field: field, direction: newDirection);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortField>>[
        _buildSortMenuItem(SortField.name, 'Sort by Name', sortCriteria),
        _buildSortMenuItem(SortField.size, 'Sort by Size', sortCriteria),
        _buildSortMenuItem(
            SortField.createdAt, 'Sort by Creation Date', sortCriteria),
        _buildSortMenuItem(
            SortField.modifiedAt, 'Sort by Modification Date', sortCriteria),
        _buildSortMenuItem(
            SortField.lastLaunchedAt, 'Sort by Last Launched', sortCriteria),
      ],
      icon: const Icon(Icons.sort),
    );
  }

  PopupMenuItem<SortField> _buildSortMenuItem(
      SortField field, String text, SortCriteria criteria) {
    return PopupMenuItem<SortField>(
      value: field,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          if (criteria.field == field)
            Icon(
              criteria.direction == SortDirection.ascending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
            ),
        ],
      ),
    );
  }

  List<AppEntity> _filterApps(List<AppEntity> apps, String filter) {
    if (filter.isEmpty) {
      return apps;
    }
    return apps
        .where((app) => app.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<AppEntity> _sortApps(List<AppEntity> apps, SortCriteria criteria) {
    apps.sort((a, b) {
      int comparison;
      switch (criteria.field) {
        case SortField.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortField.size:
          comparison = a.size.compareTo(b.size);
          break;
        case SortField.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case SortField.modifiedAt:
          comparison = a.modifiedAt.compareTo(b.modifiedAt);
          break;
        case SortField.lastLaunchedAt:
          comparison = a.lastLaunchedAt.compareTo(b.lastLaunchedAt);
          break;
      }
      return criteria.direction == SortDirection.ascending
          ? comparison
          : -comparison;
    });
    return apps;
  }
}

class AppSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  AppSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          ref.read(filterProvider.notifier).state = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ref.read(filterProvider.notifier).state = query;
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
