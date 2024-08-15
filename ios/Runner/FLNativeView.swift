import Flutter
import UIKit
import MapKit
import CoreLocation

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

class FLNativeView: NSObject, FlutterPlatformView, MKMapViewDelegate, CLLocationManagerDelegate {
    private var _view: UIView
    private var mapView: MKMapView
    private var locationManager: CLLocationManager
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
        locationManager = CLLocationManager()
        super.init()
        createNativeView(view: _view)
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view: UIView) {
        view.backgroundColor = UIColor.white
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        view.addSubview(mapView)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            
            // Adjust the zoom level for the region 
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5) 
            
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            // Stop updating location to save battery
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func animateToLocation(lat: Double, lng: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }

    func addMarker(lat: Double, lng: Double, title: String) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    func clearAllMarkers() {
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
