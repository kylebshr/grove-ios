//
//  Router.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    static let baseURL = NSURL(string: "")!

    case comments(Int)
    case hammockLocations(Double, Double, Double)

    var URL: NSURL { return Router.baseURL.URLByAppendingPathComponent(route.path) }

    var route: (path: String, parameters: [String: AnyObject]) {
        switch self {
        case .comments(let locationID):
            return ("/comment", ["id": locationID])
        case .hammockLocations(let lat, let lon, let rad):
            return ("/location", ["latitude": lat, "longitude": lon, "radius": rad])
        }
    }

    var URLRequest: NSMutableURLRequest {
        return Alamofire.ParameterEncoding.URL
            .encode(NSURLRequest(URL: URL), parameters: route.parameters).0
    }
}
