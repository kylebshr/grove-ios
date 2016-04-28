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

    let headers = [
        "Authorization": User.authenticatedUser?.authToken ?? ""
    ]

    let baseURL = NSURL(string: "https://grove-api.herokuapp.com")!
    let imageURL = NSURL(string: "https://api.cloudinary.com/v1_1/whereno/image/upload")!
    let uploadPreset = "a5txdosc"

    var currentLocationsRequest: Request?

    func postLocation(title: String, capacity: Int, description: String, imageURL: String, coordinates: CLLocationCoordinate2D, completion: Result<HammockLocation, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "title": title,
            "capacity": capacity,
            "description": description,
            "photo": imageURL,
            "latitude": coordinates.latitude.roundToPlaces(6),
            "longitude": coordinates.longitude.roundToPlaces(6),
            "user_id": User.authenticatedUser?.authToken ?? "unknown"
        ]

        Alamofire.request(.POST, baseURL.URLByAppendingPathComponent("/location"), parameters: params, encoding: .JSON)
            .responseObject { (response: Response<HammockLocation, NSError>) in

                if let location = response.result.value {
                    try! self.realm.write {
                        self.realm.add(location)
                    }
                }

                completion(response.result)
        }
    }

    func uploadImage(image: String, completion: Result<String, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "upload_preset": uploadPreset,
            "file": image
        ]

        Alamofire.request(.POST, imageURL, parameters: params, encoding: .JSON).cloudinaryURL { (response) in
            completion(response.result)
        }
    }

    func postComment(text: String, locationID: String, completion: Result<LocationComment, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "text": text,
            "location_id": locationID,
            "user_id": User.authenticatedUser?.id ?? "unknown"
        ]

        Alamofire.request(.POST, baseURL.URLByAppendingPathComponent("/comment"), parameters: params, encoding: .JSON)
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

        currentLocationsRequest?.cancel()

        currentLocationsRequest = Alamofire.request(Router.hammockLocations(region))
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
