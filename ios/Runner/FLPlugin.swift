import Flutter
import UIKit
import FLNativeView
import FLNativeViewFlutter

class FLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "SwiftUIView")
    }
}
