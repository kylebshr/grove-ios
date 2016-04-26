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

class MapViewController: UIViewController, MKMapViewDelegate, UIViewControllerPreviewingDelegate {

    @IBOutlet var mapView: RealmMapView!

    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let annotationViewReuseId = "AnnotationViewReuseId"
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

    func hammockLocationForAnnotationView(view: MKAnnotationView) -> HammockLocation? {

        guard let annotation = view.annotation as? ABFAnnotation where annotation.safeObjects.count == 1 else {
            return nil
        }

        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        let filter = "latitude == \(latitude) AND longitude == \(longitude)"

        let location = realm.objects(HammockLocation).filter(filter).first

        return location
    }

    func showNoInformationAlert() {
        let alert = UIAlertController(title: "No More Info", message: "Unfortunately, there's no more information for this location. You should go check it out!", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)

        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

        if let location = userLocation.location {
            updateLocationTitle(location)
        }

        if !didShowInitialLocation {
            updateMapRegion(userLocation.coordinate)
            didShowInitialLocation = true
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if let fetchedAnnotation = annotation as? ABFAnnotation {

            let annotationView =
                mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewReuseId) as? ABFClusterAnnotationView ??
                ABFClusterAnnotationView(annotation: fetchedAnnotation, reuseIdentifier: annotationViewReuseId)

            annotationView.canShowCallout = true
            annotationView.count = UInt(fetchedAnnotation.safeObjects.count)
            annotationView.annotation = fetchedAnnotation

            if fetchedAnnotation.safeObjects.count == 1 {
                registerForPreviewingWithDelegate(self, sourceView: annotationView)
                annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            else {
                annotationView.rightCalloutAccessoryView = nil
            }

            return annotationView
        }

        return nil
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        guard let location = hammockLocationForAnnotationView(view) else {
            showNoInformationAlert()
            return
        }

        let vc = R.storyboard.main.locationDetailViewController()!
        vc.location = location
        navigationController?.pushViewController(vc, animated: true)
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        if let tappedView = previewingContext.sourceView as? ABFClusterAnnotationView, hammockLocation = hammockLocationForAnnotationView(tappedView) {

            previewingContext.sourceRect = CGRect(x: 0, y: 0, width: tappedView.frame.width, height: tappedView.frame.height)

            let vc = R.storyboard.main.locationDetailViewController()!
            vc.location = hammockLocation
            vc.shouldShowTextInputView = false
            return vc
        }

        return nil
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        if let vc = viewControllerToCommit as? LocationDetailViewController {
            vc.shouldShowTextInputView = true
            navigationController?.pushViewController(viewControllerToCommit, animated: true)
        }
    }
}
