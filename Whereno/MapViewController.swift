//
//  ViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import RealmMapView

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: RealmMapView!

    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()

    var didShowInitialLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.zoomOnFirstRefresh = false
        requestLocationPermissionIfNeeded()
    }

    @IBAction func locationButtonTapped(sender: UIBarButtonItem) {
       updateMapRegion(mapView.userLocation.coordinate)
    }

    func requestLocationPermissionIfNeeded() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func updateMapRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

    func updateLocationTitle(location: CLLocation) {

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in

            // TODO: do on main thread?

            guard let locality = placemarks?.first?.locality else {
                self?.title = "Current Location"
                return
            }

            self?.title = locality
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
}
