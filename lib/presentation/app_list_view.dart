import 'package:flutter/material.dart';
import 'package:myapp/models/app_entity.dart';
import 'package:myapp/presentation/widgets/app_list_item.dart';

class AppListView extends StatelessWidget {
  final List<AppEntity> apps;

  const AppListView({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return AppListItem(app: app);
      },
    );
  }
}
