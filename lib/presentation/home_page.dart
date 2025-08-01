import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/application_discovery_service_impl.dart';
import 'package:myapp/domain/sort_criteria.dart';
import 'package:myapp/models/app_entity.dart';
import 'package:myapp/presentation/app_list_view.dart';
import 'package:myapp/presentation/providers.dart';

final appListProvider = StateProvider<List<AppEntity>>((ref) => []);
final isLoadingProvider = StateProvider<bool>((ref) => false);
final sortCriteriaProvider = StateProvider<SortCriteria>(
    (ref) => SortCriteria(field: SortField.name, direction: SortDirection.ascending));

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appList = ref.watch(appListProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final sortCriteria = ref.watch(sortCriteriaProvider);

    final sortedAppList = _sortApps(appList, sortCriteria);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AppManager',
          style: GoogleFonts.sora(fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildSortMenu(ref),
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            tooltip: 'Clear Cache & Rescan',
            onPressed: () async {
              ref.read(isLoadingProvider.notifier).state = true;
              await (ref.read(applicationDiscoveryServiceProvider)
                      as ApplicationDiscoveryServiceImpl)
                  .clear();
              final apps = await ref
                  .read(applicationDiscoveryServiceProvider)
                  .discoverApplications();
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
              ? buildEmptyState(context, ref)
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
        const PopupMenuItem<SortField>(
          value: SortField.name,
          child: Text('Sort by Name'),
        ),
        const PopupMenuItem<SortField>(
          value: SortField.size,
          child: Text('Sort by Size'),
        ),
        const PopupMenuItem<SortField>(
          value: SortField.createdAt,
          child: Text('Sort by Creation Date'),
        ),
        const PopupMenuItem<SortField>(
          value: SortField.modifiedAt,
          child: Text('Sort by Modification Date'),
        ),
        const PopupMenuItem<SortField>(
          value: SortField.lastLaunchedAt,
          child: Text('Sort by Last Launched'),
        ),
      ],
      icon: const Icon(Icons.sort),
    );
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

  Widget buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.rocket_launch_outlined,
            size: 120,
            color: Colors.blue,
          ),
          const SizedBox(height: 30),
          Text(
            'Welcome to AppManager',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 15),
          Text(
            'Get ready to reclaim your disk space.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () async {
              ref.read(isLoadingProvider.notifier).state = true;
              final apps = await ref
                  .read(applicationDiscoveryServiceProvider)
                  .discoverApplications();
              ref.read(appListProvider.notifier).state = apps;
              ref.read(isLoadingProvider.notifier).state = false;
            },
            icon: const Icon(Icons.search),
            label: const Text('Scan for Applications'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
