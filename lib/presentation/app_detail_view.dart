import 'package:flutter/material.dart';
import 'package:myapp/models/app_entity.dart';
import 'package:myapp/presentation/widgets/detail_row.dart';

class AppDetailView extends StatelessWidget {
  final AppEntity app;

  const AppDetailView({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(app.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                app.iconData.isNotEmpty
                    ? Image.memory(app.iconData, width: 64, height: 64)
                    : const Icon(Icons.apps, size: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text(app.bundleId),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            DetailRow(title: 'Path', value: app.path),
            DetailRow(title: 'Size', value: '${(app.size / 1024 / 1024).toStringAsFixed(2)} MB'),
            DetailRow(title: 'Created', value: app.createdAt.toLocal().toString()),
            DetailRow(title: 'Modified', value: app.modifiedAt.toLocal().toString()),
            DetailRow(title: 'Last Launched', value: app.lastLaunchedAt.toLocal().toString()),
            DetailRow(title: 'System App', value: app.isSystemApp ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }
}
