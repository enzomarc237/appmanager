import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/application_discovery_service_impl.dart';
import 'package:myapp/models/app_entity.dart';
import 'package:myapp/presentation/app_list_view.dart';
import 'package:myapp/presentation/providers.dart';

final appListProvider = StateProvider<List<AppEntity>>((ref) => []);
final isLoadingProvider = StateProvider<bool>((ref) => false);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appList = ref.watch(appListProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AppManager',
          style: GoogleFonts.sora(fontWeight: FontWeight.bold),
        ),
        actions: [
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
          : appList.isEmpty
              ? buildEmptyState(context, ref)
              : AppListView(apps: appList),
    );
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
