import 'package:flutter/material.dart';
import 'package:myapp/models/app_entity.dart';

class AppListView extends StatelessWidget {
  final List<AppEntity> apps;

  const AppListView({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return ListTile(
          leading: app.iconData.isNotEmpty
              ? Image.memory(app.iconData)
              : const Icon(Icons.apps),
          title: Text(app.name),
          subtitle: Text(
              '${(app.size / 1024 / 1024).toStringAsFixed(2)} MB - Last Launched: ${app.lastLaunchedAt.toLocal()}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // TODO: Implement uninstallation
            },
          ),
        );
      },
    );
  }
}
