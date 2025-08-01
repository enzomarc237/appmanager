import 'package:flutter/material.dart';
import 'package:myapp/models/app_entity.dart';

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
            _buildDetailRow('Path', app.path),
            _buildDetailRow('Size', '${(app.size / 1024 / 1024).toStringAsFixed(2)} MB'),
            _buildDetailRow('Created', app.createdAt.toLocal().toString()),
            _buildDetailRow('Modified', app.modifiedAt.toLocal().toString()),
            _buildDetailRow('Last Launched', app.lastLaunchedAt.toLocal().toString()),
            _buildDetailRow('System App', app.isSystemApp ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(value, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
