import 'dart:typed_data';

class AppEntity {
  final String id;
  final String name;
  final String bundleId;
  final String path;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime lastLaunchedAt;
  final int size;
  final Uint8List iconData;
  final bool isSystemApp;

  AppEntity({
    required this.id,
    required this.name,
    required this.bundleId,
    required this.path,
    required this.createdAt,
    required this.modifiedAt,
    required this.lastLaunchedAt,
    required this.size,
    required this.iconData,
    required this.isSystemApp,
  });
}
