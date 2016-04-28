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

class NetworkManager {

    static let sharedInstance = NetworkManager()

    let realm = try! Realm()

    let headers = [
        "Authorization": User.authToken ?? ""
    ]

    let baseURL = NSURL(string: "https://grove-api.herokuapp.com")!
    let imageURL = NSURL(string: "https://api.cloudinary.com/v1_1/whereno/image/upload")!
    let uploadPreset = "a5txdosc"

    var currentLocationsRequest: Request?

    func postLocation(title: String, capacity: Int, description: String, imageURL: String, latitude: Double,
                      longitude: Double, completion: Result<HammockLocation, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "title": title,
            "capacity": capacity,
            "description": description,
            "photo": imageURL,
            "latitude": latitude.roundToPlaces(6),
            "longitude": longitude.roundToPlaces(6),
            "user_id": "kylebashour"
        ]

        Alamofire.request(.POST, baseURL.URLByAppendingPathComponent("/location"), parameters: params, encoding: .JSON)
            .responseObject { (response: Response<HammockLocation, NSError>) in
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

    func postComment(text: String, locationID: Int, completion: Result<HammockLocation, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "text": text,
            "location_id": locationID,
            "user_id": "kylebashour"
        ]

        Alamofire.request(.POST, baseURL.URLByAppendingPathComponent("/comment"), parameters: params, encoding: .JSON)
            .responseObject { (response) in
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
