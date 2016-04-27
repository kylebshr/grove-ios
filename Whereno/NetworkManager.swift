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

    func postLocation(title: String,
                      description: String,
                      photoData: String,
                      latitude: Double,
                      longitude: Double,
                      completion: ((Result<HammockLocation, NSError>) -> Void)) {

        let params: [String: AnyObject] = [
            "title": title,
            "description": description,
            "photo": photoData,
            "latitude": latitude,
            "longitude": longitude
        ]

        Alamofire.request(.POST, baseURL, parameters: params, encoding: .JSON)
            .responseObject { (response: Response<HammockLocation, NSError>) in
                completion(response.result)
        }
    }
}
