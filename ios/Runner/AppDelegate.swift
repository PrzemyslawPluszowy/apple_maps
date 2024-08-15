import Flutter
import UIKit

@main
class AppDelegate: FlutterAppDelegate {
    private var mapViewFactory: FLNativeViewFactory?
    private var views: [Int64: FLNativeView] = [:] 

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        mapViewFactory = FLNativeViewFactory(messenger: controller.binaryMessenger)
        registrar(forPlugin: "SwiftUIView")?.register(mapViewFactory!, withId: "SwiftUIView",gestureRecognizersBlockingPolicy:FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)
        
        let channel = FlutterMethodChannel(name: "com.example/map", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "animateToLocation" {
                guard let args = call.arguments as? [String: Any],
                      let lat = args["lat"] as? Double,
                      let lng = args["lng"] as? Double,
                      let viewId = args["viewId"] as? Int64 else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                self?.views[viewId]?.animateToLocation(lat: lat, lng: lng)
                result("Success")
            } else if call.method == "addMarker"{
                guard let args = call.arguments as? [String: Any],
                      let lat = args["lat"] as? Double,
                      let lng = args["lng"] as? Double,
                      
                      let title = args["title"] as? String,
                      let viewId = args["viewId"] as? Int64 else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                self?.views[viewId]?.addMarker(lat: lat, lng: lng, title: title)
                result("Success")
            }
            else if call.method == "clearAllMarkers" {
                guard let args = call.arguments as? [String: Any],
                      let viewId = args["viewId"] as? Int64 else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                self?.views[viewId]?.clearAllMarkers()
                result("Success")
            }
            else  {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func registerView(_ view: FLNativeView, forId viewId: Int64) {
        views[viewId] = view
    }
}