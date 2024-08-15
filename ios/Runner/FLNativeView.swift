import Flutter
import UIKit
import MapKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let nativeView = FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.registerView(nativeView, forId: viewId)
        }
        return nativeView
    }
}

// Class implementing the native iOS view with Apple Maps
class FLNativeView: NSObject, FlutterPlatformView, MKMapViewDelegate {
    private var _view: UIView
    private var mapView: MKMapView
    private var messenger: FlutterBinaryMessenger?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        self.messenger = messenger
        _view = UIView(frame: frame)
        mapView = MKMapView(frame: _view.bounds)
        super.init()
        createNativeView(view: _view)
        mapView.delegate = self
    }

    // Returns the view to be embedded in the Flutter interface
    func view() -> UIView {
        return _view
    }

    // Creates and configures the native Apple Maps view
    func createNativeView(view: UIView) {
        view.backgroundColor = UIColor.white
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }

    // Animates the map to the specified location
    func animateToLocation(lat: Double, lng: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }

    // Adds a marker to the map at the specified location with a title
    func addMarker(lat: Double, lng: Double, title: String) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    // Clears all markers from the map
    func clearAllMarkers() {
        mapView.removeAnnotations(mapView.annotations)
    }

    // Called when the user taps a marker on the map; sends data to Flutter
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let lat = annotation.coordinate.latitude
            let lng = annotation.coordinate.longitude
            let title = annotation.title ?? ""

            let channel = FlutterMethodChannel(name: "com.example/map_marker_click", binaryMessenger: messenger!)
            channel.invokeMethod("onMarkerClick", arguments: ["lat": lat, "lng": lng, "title": title])
        }
    }
}
