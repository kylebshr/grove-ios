//
//  NetworkManager.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/27/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import Alamofire
import MapKit
import RealmSwift

class ObjectFetcher {

    static let sharedInstance = ObjectFetcher()

    let realm = try! Realm()
    let locationDecimalAccuracy = 7

    // We want to cancel this when we make a new one
    var currentLocationsRequest: Request?

    func postLocation(title: String, capacity: Int, description: String, imageURL: String, coordinates: CLLocationCoordinate2D, completion: Result<HammockLocation, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "title": title,
            "capacity": capacity,
            "description": description,
            "photo": imageURL,
            "latitude": coordinates.latitude.roundToPlaces(locationDecimalAccuracy),
            "longitude": coordinates.longitude.roundToPlaces(locationDecimalAccuracy),
        ]

        Alamofire.request(Router.locationPost(params))
            .responseObject { (response: Response<HammockLocation, NSError>) in

                if let location = response.result.value {
                    try! self.realm.write {
                        self.realm.add(location)
                    }
                }

                completion(response.result)
        }
    }

    func uploadImage(image: UIImage, completion: Result<String, NSError> -> Void) {

        guard let imageData = image.encode() else {
            completion(.Failure(NetworkError.errorWithType(.failedToEncodeImage)))
            return
        }

        Alamofire.request(Router.imagePost(imageData)).cloudinaryURL { (response) in
            completion(response.result)
        }
    }

    func postComment(text: String, locationID: String, completion: Result<LocationComment, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "text": text,
            "location_id": locationID,
        ]

        Alamofire.request(Router.commentPost(params))
            .responseObject { (response: Response<LocationComment, NSError>) in

                if let comment = response.result.value {
                    try! self.realm.write {
                        self.realm.objects(HammockLocation)
                            .filter("id == '\(locationID)'")
                            .first?.comments.append(comment)
                    }
                }

                completion(response.result)
        }
    }

    func getLocationsForRegion(region: MKCoordinateRegion, completion: Result<[HammockLocation], NSError> -> Void) {

        // Cancel this, as it could be called a whole lot as we pan
        currentLocationsRequest?.cancel()

        currentLocationsRequest = Alamofire.request(Router.locationFeed(region))
            .responseCollection { (response: Response<[HammockLocation], NSError>) in

                switch response.result {
                case .Success(let locations):

                    try! self.realm.write {
                        self.realm.add(locations, update: true)
                    }

                case .Failure: break
                }

                completion(response.result)
        }
    }
}
