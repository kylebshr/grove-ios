//
//  NetworkManager.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/27/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {

    static let sharedInstance = NetworkManager()

    let headers = [
        "Authorization": User.authToken ?? ""
    ]

    let baseURL = "https://kylebashour.com/"
    let imageURL = "https://api.cloudinary.com/v1_1/whereno/image/upload"
    let uploadPreset = "a5txdosc"

    func postLocation(title: String,
                      capacity: Int,
                      description: String,
                      imageURL: String,
                      latitude: Double,
                      longitude: Double,
                      completion: Result<HammockLocation, NSError> -> Void) {

        let params: [String: AnyObject] = [
            "title": title,
            "description": description,
            "photo": imageURL,
            "latitude": latitude,
            "longitude": longitude
        ]

        Alamofire.request(.POST, baseURL, parameters: params, encoding: .JSON)
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
}
