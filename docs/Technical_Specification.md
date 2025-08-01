# Technical Specification: AppManager

## Architecture Overview

### Technology Stack
- **UI Framework:** Flutter 3.10+
- **Programming Language:** Dart 3.0+
- **Native Integration:** Swift for macOS-specific functionality
- **Database:** SQLite for application metadata caching
- **State Management:** Flutter Riverpod

### System Architecture
The application follows a clean architecture pattern with the following layers:

1. **Presentation Layer**
   - Flutter UI components
   - State management using Riverpod
   - Navigation handling

2. **Domain Layer**
   - Business logic
   - Entity models
   - Repository interfaces

3. **Data Layer**
   - Repository implementations
   - Data sources (local file system, SQLite)
   - Platform-specific code via method channels

4. **Infrastructure Layer**
   - macOS system integration
   - File system operations
   - Permission handling

## Core Components

### Application Discovery Module
Responsible for scanning the file system to identify installed applications.

#### Implementation Details
- Use NSWorkspace and FileManager APIs through method channels
- Scan standard application directories (/Applications, ~/Applications)
- Support for custom directory scanning
- Implement caching to improve subsequent scan performance
- Background scanning capability using isolates

```dart
class ApplicationDiscoveryService {
  Future<List<AppEntity>> discoverApplications() async {
    // Implementation using method channel to native code
  }
  
  Future<void> scanDirectory(String path) async {
    // Scan specific directory for applications
  }
}
```

### Metadata Extraction Module
Extracts and processes metadata for discovered applications.

#### Implementation Details
- Use NSFileManager and MDItemCreate APIs through method channels
- Extract creation date, modification date, and last opened date
- Calculate application size recursively
- Extract application icons as images
- Cache metadata in SQLite database

```dart
class MetadataExtractor {
  Future<AppMetadata> extractMetadata(String appPath) async {
    // Implementation using method channel to native code
  }
  
  Future<int> calculateAppSize(String appPath) async {
    // Calculate total size of application bundle
  }
}
```

### UI Components

#### Application List Component
- Virtualized list view for performance with large numbers of apps
- Custom list item widget with application icon, name, and metadata
- Sort controls for different metadata fields
- Search and filter functionality

```dart
class AppListView extends StatelessWidget {
  final List<AppEntity> apps;
  final SortCriteria sortCriteria;
  
  @override
  Widget build(BuildContext context) {
    // Implementation of the list view
  }
}
```

#### Application Detail Component
- Detailed view of a selected application
- Expanded metadata display
- Action buttons for uninstallation

```dart
class AppDetailView extends StatelessWidget {
  final AppEntity app;
  
  @override
  Widget build(BuildContext context) {
    // Implementation of the detail view
  }
}
```

#### Uninstallation Module
- Handles the safe removal of applications
- Implements both trash and permanent deletion options
- Manages permissions and security concerns

```dart
class UninstallationService {
  Future<bool> moveToTrash(AppEntity app) async {
    // Implementation using method channel to native code
  }
  
  Future<bool> deletePermenantly(AppEntity app) async {
    // Implementation with confirmation and security checks
  }
}
```

## Data Models

### AppEntity
Represents an application discovered on the system.

```dart
class AppEntity {
  final String id;          // Unique identifier
  final String name;        // Application name
  final String bundleId;    // Bundle identifier
  final String path;        // Path to .app bundle
  final DateTime createdAt; // Creation date
  final DateTime modifiedAt; // Last modification date
  final DateTime lastLaunchedAt; // Last launch date
  final int size;           // Size in bytes
  final Uint8List iconData; // Application icon as bytes
  final bool isSystemApp;   // Whether it's a system application
  
  // Constructor and methods
}
```

### SortCriteria
Defines how applications are sorted in the list.

```dart
enum SortField {
  name,
  size,
  createdAt,
  modifiedAt,
  lastLaunchedAt,
}

enum SortDirection {
  ascending,
  descending,
}

class SortCriteria {
  final SortField field;
  final SortDirection direction;
  
  // Constructor and methods
}
```

## Native Integration

### Method Channels
Flutter method channels for communication with native Swift code.

```dart
// Dart side
final MethodChannel _channel = MethodChannel('com.appmanager/system');

// Method calls
Future<List<String>> getApplicationPaths() async {
  return await _channel.invokeListMethod<String>('getApplicationPaths') ?? [];
}
```

### Swift Implementation
Native Swift code for system integration.

```swift
// Swift side
private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  switch call.method {
  case "getApplicationPaths":
    let appPaths = getInstalledApplicationPaths()
    result(appPaths)
  // Other methods
  default:
    result(FlutterMethodNotImplemented)
  }
}

private func getInstalledApplicationPaths() -> [String] {
  // Implementation using NSWorkspace
}
```

## Database Schema

### Applications Table
```sql
CREATE TABLE applications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  bundle_id TEXT,
  path TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  modified_at INTEGER NOT NULL,
  last_launched_at INTEGER,
  size INTEGER NOT NULL,
  icon_data BLOB,
  is_system_app INTEGER NOT NULL
);
```

### Scan History Table
```sql
CREATE TABLE scan_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp INTEGER NOT NULL,
  apps_count INTEGER NOT NULL
);
```

## Performance Considerations

### Large Application Sets
- Implement virtualized lists to handle 1000+ applications smoothly
- Use background isolates for scanning and metadata extraction
- Implement incremental scanning for subsequent app launches

### Memory Management
- Load application icons on-demand and cache them efficiently
- Implement memory-efficient image handling
- Use pagination for large datasets

### Disk Access Optimization
- Implement caching to minimize repeated file system operations
- Use batched database operations
- Optimize recursive directory scanning algorithms

## Security and Permissions

### Required Entitlements
- File system access entitlements for scanning applications
- Trash access for moving applications to trash

### Permission Handling
- Request permissions at appropriate times with clear explanations
- Gracefully handle permission denials with helpful guidance

### Sandboxing Considerations
- Design file access to work within App Store sandboxing restrictions
- Implement security-focused file operations

## Testing Strategy

### Unit Tests
- Test business logic and data processing
- Mock file system operations for predictable testing

### Integration Tests
- Test native code integration
- Verify database operations

### UI Tests
- Test sorting and filtering functionality
- Verify list performance with large datasets

### Manual Testing
- Verify uninstallation functionality on various macOS versions
- Test with a diverse set of applications (system apps, third-party apps)

## Deployment and Distribution

### Build Process
- Flutter build for macOS with appropriate configuration
- Code signing and notarization for macOS distribution
- App Store preparation (optional)

### Distribution Options
- Direct download from website
- App Store distribution
- Homebrew package

## Future Technical Considerations

### Potential Optimizations
- Implement file system monitoring for real-time updates
- Add application usage tracking for more accurate "last used" data
- Develop plugins for additional application sources

### Scalability
- Design for handling extremely large application libraries
- Support for external drives and network volumes

### Extensibility
- Plugin architecture for adding new features
- API for integration with other system maintenance tools