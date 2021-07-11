import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    application.applicationIconBadgeNumber = 0
    GeneratedPluginRegistrant.register(with: self)
    if let flutterPluginRegistrar = self.registrar(forPlugin: "BleNetworkPlugin") {
        BleNetworkPlugin.register(with: flutterPluginRegistrar)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_: UIApplication) {
      UIApplication.shared.applicationIconBadgeNumber = 0
  }

  override func applicationWillResignActive(_: UIApplication) {
      UIApplication.shared.applicationIconBadgeNumber = 0
  }
}
