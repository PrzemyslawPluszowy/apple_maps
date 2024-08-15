
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
        _view = UIView()
        mapView = MKMapView(frame: _view.bounds)
        super.init()
        createNativeView(view: _view)
        mapView.delegate = self  // Ustawienie delegata
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView) {
        _view.backgroundColor = UIColor.white
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _view.addSubview(mapView)
    }

    func animateToLocation(lat: Double, lng: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }

    func addMarker(lat: Double, lng: Double, title: String) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = MKPointAnnotation(

        )
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    func clearAllMarkers(
    ) {
        mapView.removeAnnotations(mapView.annotations)
    }
    

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