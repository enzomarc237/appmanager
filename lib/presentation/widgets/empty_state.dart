import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/presentation/providers.dart';
import 'package:myapp/presentation/home_page.dart';

class EmptyState extends ConsumerWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
