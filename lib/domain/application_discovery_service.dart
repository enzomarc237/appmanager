import 'package:myapp/models/app_entity.dart';

abstract class ApplicationDiscoveryService {
  Future<List<AppEntity>> discoverApplications();
  Future<void> scanDirectory(String path);
  Future<void> delete(String id);
}
