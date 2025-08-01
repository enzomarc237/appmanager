import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/linux_discovery_service.dart';
import 'package:myapp/data/macos_discovery_service.dart';
import 'package:myapp/domain/application_discovery_service.dart';

final applicationDiscoveryServiceProvider =
    Provider<ApplicationDiscoveryService>((ref) {
  if (Platform.isMacOS) {
    return MacOSDiscoveryService();
  } else if (Platform.isLinux) {
    return LinuxDiscoveryService();
  } else {
    throw UnsupportedError('Unsupported platform');
  }
});
