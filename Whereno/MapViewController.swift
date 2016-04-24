//
//  ViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import RealmMapView
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: RealmMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        mapView.setCenterCoordinate(userLocation.coordinate, animated: true)
    }
}
