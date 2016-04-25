//
//  ViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import RealmSwift
import RealmMapView
import Async

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: RealmMapView!

    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let annotationViewReuseId = "ABFAnnotationViewReuseId"

    var didShowInitialLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Zooms into random cluster unless we set to false
        mapView.zoomOnFirstRefresh = false

        requestLocationPermissionIfNeeded()
    }

    // Centers and zooms the map to your current location
    @IBAction func locationButtonTapped(sender: UIBarButtonItem) {
        updateMapRegion(mapView.userLocation.coordinate)
    }

    // Ask for location use permission if not granted
    func requestLocationPermissionIfNeeded() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // Create a region from coordinates and animate to that region
    func updateMapRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

    // Reverse geocode the user location for the nav bar title
    func updateLocationTitle(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in

            // Placemarks and UI updates should be worked with on main thread
            Async.main {
                guard let locality = placemarks?.first?.locality else {
                    self?.title = "Current Location"
                    return
                }

                self?.title = locality
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

        if let location = userLocation.location {
            updateLocationTitle(location)
        }

        if !didShowInitialLocation {
            updateMapRegion(userLocation.coordinate)
            didShowInitialLocation = true
        }
    }

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapView.refreshMapView()
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if let fetchedAnnotation = annotation as? ABFAnnotation {

            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewReuseId) as? ABFClusterAnnotationView

            if annotationView == nil {
                annotationView = ABFClusterAnnotationView(annotation: fetchedAnnotation, reuseIdentifier: annotationViewReuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }

            annotationView!.count = UInt(fetchedAnnotation.safeObjects.count)
            annotationView!.annotation = fetchedAnnotation

            return annotationView!
        }

        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(try! Realm().objects(HammockLocation).filter("latitude == \(view.annotation!.coordinate.latitude) AND longitude == \(view.annotation!.coordinate.longitude)"))
    }
}
