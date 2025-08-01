import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    let discoveryChannel = FlutterMethodChannel(name: "com.appmanager/system",
                                                binaryMessenger: flutterViewController.engine.binaryMessenger)
    let appDiscovery = AppDiscovery()

    discoveryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "getApplications":
        result(appDiscovery.getInstalledApplications())
      case "scanDirectory":
        // Not implemented yet
        result(FlutterMethodNotImplemented)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
