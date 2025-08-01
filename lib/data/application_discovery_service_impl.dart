import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:myapp/data/app_repository.dart';
import 'package:myapp/domain/application_discovery_service.dart';
import 'package:myapp/models/app_entity.dart';

class ApplicationDiscoveryServiceImpl implements ApplicationDiscoveryService {
  final AppRepository _appRepository = AppRepository();
  static const platform = MethodChannel('com.appmanager/system');

  @override
  Future<List<AppEntity>> discoverApplications() async {
    List<AppEntity> apps = await _appRepository.getAllApps();
    if (apps.isNotEmpty) {
      return apps;
    }

    apps = await _getAppsFromNative();
    for (var app in apps) {
      await _appRepository.insert(app);
    }
    return apps;
  }

  @override
  Future<void> scanDirectory(String path) async {
    await platform.invokeMethod('scanDirectory', {'path': path});
  }

  @override
  Future<void> delete(String id) async {
    await _appRepository.delete(id);
    await platform.invokeMethod('delete', {'id': id});
  }

  Future<void> clear() async {
    await _appRepository.clearAll();
  }

  Future<List<AppEntity>> _getAppsFromNative() async {
    final List<dynamic> result = await platform.invokeMethod('getApplications');
    return result.map((e) => _mapToApp(e)).toList();
  }

  AppEntity _mapToApp(Map<dynamic, dynamic> map) {
    return AppEntity(
      id: map['bundleId'] ?? '',
      name: map['name'] ?? 'Unknown',
      bundleId: map['bundleId'] ?? '',
      path: map['path'] ?? '',
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      modifiedAt:
          DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'] ?? 0),
      lastLaunchedAt:
          DateTime.fromMillisecondsSinceEpoch(map['lastLaunchedAt'] ?? 0),
      size: map['size'] ?? 0,
      iconData: map['icon'] is Uint8List ? map['icon'] : Uint8List(0),
      isSystemApp: map['isSystemApp'] ?? false,
    );
  }
}
