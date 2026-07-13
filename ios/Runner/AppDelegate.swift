import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     GMSServices.provideAPIKey("AIzaSyA9ywGK0_Oy4kfKX7Un2pkSgHkoUyAiddo")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
