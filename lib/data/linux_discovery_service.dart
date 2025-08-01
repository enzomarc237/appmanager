import 'dart:typed_data';
import 'package:myapp/data/app_repository.dart';
import 'package:myapp/domain/application_discovery_service.dart';
import 'package:myapp/models/app_entity.dart';

class LinuxDiscoveryService implements ApplicationDiscoveryService {
  final AppRepository _appRepository = AppRepository();

  @override
  Future<List<AppEntity>> discoverApplications() async {
    List<AppEntity> apps = await _appRepository.getAllApps();
    if (apps.isNotEmpty) {
      return apps;
    }

    // For now, return a hardcoded list of applications for UI development.
    // The actual implementation would parse .desktop files.
    apps = await _getMockApps();
    for (var app in apps) {
      await _appRepository.insert(app);
    }
    return apps;
  }

  @override
  Future<void> scanDirectory(String path) async {
    // This would be implemented to scan for .desktop files in a specific directory.
    return Future.value();
  }

  @override
  Future<void> delete(String id) async {
    // This would be implemented to delete the .desktop file.
    await _appRepository.delete(id);
  }

  Future<void> clear() async {
    await _appRepository.clearAll();
  }

  Future<List<AppEntity>> _getMockApps() {
    return Future.delayed(const Duration(seconds: 1), () {
      return [
        AppEntity(
          id: 'firefox.desktop',
          name: 'Firefox',
          bundleId: 'firefox.desktop',
          path: '/usr/share/applications/firefox.desktop',
          createdAt: DateTime(2023, 1, 1),
          modifiedAt: DateTime(2023, 10, 1),
          lastLaunchedAt: DateTime(2023, 11, 1),
          size: 150000000,
          iconData: Uint8List(0), // Placeholder for icon
          isSystemApp: true,
        ),
        AppEntity(
          id: 'gedit.desktop',
          name: 'gedit',
          bundleId: 'gedit.desktop',
          path: '/usr/share/applications/gedit.desktop',
          createdAt: DateTime(2023, 1, 1),
          modifiedAt: DateTime(2023, 1, 1),
          lastLaunchedAt: DateTime(2023, 10, 20),
          size: 5000000,
          iconData: Uint8List(0), // Placeholder for icon
          isSystemApp: true,
        ),
      ];
    });
  }
}
