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
    let realm = try! Realm()

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

    func showNoInformationAlert() {
        let alert = UIAlertController(title: "No More Info", message: "Unfortunately, there's no more information for this location. You should go check it out!", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)

        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
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
            }

            annotationView!.rightCalloutAccessoryView =
                fetchedAnnotation.safeObjects.count == 1 ? UIButton(type: .DetailDisclosure) : nil
            annotationView!.count = UInt(fetchedAnnotation.safeObjects.count)
            annotationView!.annotation = fetchedAnnotation

            return annotationView!
        }

        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        guard let annotation = view.annotation else {
            return
        }

        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        let filter = "latitude == \(latitude) AND longitude == \(longitude)"

        guard let location = realm.objects(HammockLocation).filter(filter).first else {
            showNoInformationAlert()
            return
        }

        print(location.id, location.title)
    }
}
