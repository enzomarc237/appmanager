import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/application_discovery_service_impl.dart';
import 'package:myapp/domain/application_discovery_service.dart';

final applicationDiscoveryServiceProvider =
    Provider<ApplicationDiscoveryService>((ref) {
  return ApplicationDiscoveryServiceImpl();
});
