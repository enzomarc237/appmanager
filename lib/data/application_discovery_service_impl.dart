import 'dart:typed_data';
import 'package:myapp/domain/application_discovery_service.dart';
import 'package:myapp/models/app_entity.dart';

class ApplicationDiscoveryServiceImpl implements ApplicationDiscoveryService {
  @override
  Future<List<AppEntity>> discoverApplications() async {
    // For now, return a hardcoded list of applications for UI development.
    // The actual implementation will use method channels to call native code.
    return Future.delayed(const Duration(seconds: 2), () {
      return [
        AppEntity(
          id: 'com.apple.dt.xcode',
          name: 'Xcode',
          bundleId: 'com.apple.dt.xcode',
          path: '/Applications/Xcode.app',
          createdAt: DateTime(2023, 1, 15),
          modifiedAt: DateTime(2023, 10, 26),
          lastLaunchedAt: DateTime(2023, 11, 1),
          size: 12884901888,
          iconData: Uint8List(0), // Placeholder for icon
          isSystemApp: true,
        ),
        AppEntity(
          id: 'com.google.chrome',
          name: 'Google Chrome',
          bundleId: 'com.google.chrome',
          path: '/Applications/Google Chrome.app',
          createdAt: DateTime(2022, 8, 20),
          modifiedAt: DateTime(2023, 10, 30),
          lastLaunchedAt: DateTime(2023, 11, 2),
          size: 482344960,
          iconData: Uint8List(0), // Placeholder for icon
          isSystemApp: false,
        ),
        AppEntity(
          id: 'com.figma.desktop',
          name: 'Figma',
          bundleId: 'com.figma.desktop',
          path: '/Applications/Figma.app',
          createdAt: DateTime(2023, 3, 10),
          modifiedAt: DateTime(2023, 10, 15),
          lastLaunchedAt: DateTime(2023, 10, 28),
          size: 278528000,
          iconData: Uint8List(0), // Placeholder for icon
          isSystemApp: false,
        ),
      ];
    });
  }

  @override
  Future<void> scanDirectory(String path) async {
    // In the future, this will trigger a scan in a specific directory.
    // For now, it does nothing.
    return Future.value();
  }
}
