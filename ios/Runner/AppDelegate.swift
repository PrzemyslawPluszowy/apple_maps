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
        // Registers the factory to create native views with a specific ID ("SwiftMapView")
        // don't remove [gestureRecognizersBlockingPolicy] this function fix bug for turnoff gesture after change context in MapKIT!!!!!!!!
        registrar(forPlugin: "SwiftMapView")?.register(mapViewFactory!, withId: "SwiftMapView", gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)
        
        // Creates a method channel for communication between Flutter and iOS
        let channel = FlutterMethodChannel(name: "com.example/map", binaryMessenger: controller.binaryMessenger)
        // Sets a handler to respond to method calls from Flutter
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            // Checks if the Flutter call is to animate the map to a specific location
            if call.method == "animateToLocation" {
                guard let args = call.arguments as? [String: Any],
                      let lat = args["lat"] as? Double,
                      let lng = args["lng"] as? Double,
                      let viewId = args["viewId"] as? Int64 else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                // Animates the map to the given latitude and longitude
                self?.views[viewId]?.animateToLocation(lat: lat, lng: lng)
                result("Success")
            // Checks if the Flutter call is to add a marker to the map
            } else if call.method == "addMarker" {
                guard let args = call.arguments as? [String: Any],
                      let lat = args["lat"] as? Double,
                      let lng = args["lng"] as? Double,
                      let title = args["title"] as? String,
                      let viewId = args["viewId"] as? Int64 else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                // Adds a marker to the map at the specified location with a title
                self?.views[viewId]?.addMarker(lat: lat, lng: lng, title: title)
                result("Success")
            // Checks if the Flutter call is to clear all markers from the map
            } else if call.method == "clearAllMarkers" {
                guard let args = call.arguments as? [String: Any],
                      let viewId = args["viewId"] as? Int64 else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                // Clears all markers from the map
                self?.views[viewId]?.clearAllMarkers()
                result("Success")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Registers a native view with a given ID so it can be managed later
    func registerView(_ view: FLNativeView, forId viewId: Int64) {
        views[viewId] = view
    }
}