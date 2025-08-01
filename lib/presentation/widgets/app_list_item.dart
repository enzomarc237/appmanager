import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/app_entity.dart';
import 'package:myapp/presentation/app_detail_view.dart';
import 'package:myapp/presentation/providers.dart';
import 'package:myapp/presentation/home_page.dart';

class AppListItem extends ConsumerWidget {
  final AppEntity app;

  const AppListItem({super.key, required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getLaunchColor(app.lastLaunchedAt);

    return ListTile(
      leading: Container(
        width: 4,
        height: 40,
        color: color,
      ),
      title: Text(app.name),
      subtitle: Text(
          '${(app.size / 1024 / 1024).toStringAsFixed(2)} MB - Last Launched: ${app.lastLaunchedAt.toLocal()}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Uninstall Application'),
                content:
                    Text('Are you sure you want to uninstall ${app.name}?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Uninstall'),
                    onPressed: () async {
                      await ref
                          .read(applicationDiscoveryServiceProvider)
                          .delete(app.id);
                      ref.refresh(appListProvider);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppDetailView(app: app),
          ),
        );
      },
    );
  }

  Color _getLaunchColor(DateTime lastLaunchedAt) {
    final now = DateTime.now();
    final difference = now.difference(lastLaunchedAt);

    if (difference.inDays > 365) {
      return Colors.red;
    } else if (difference.inDays > 180) {
      return Colors.orange;
    } else if (difference.inDays > 90) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
