//
//  Router.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

enum Router: URLRequestConvertible {

    case locationFeed(MKCoordinateRegion)
    case commentsForLocation(String)
    case locationPost([String: AnyObject])
    case commentPost([String: AnyObject])
    case imagePost(String)

    var baseURL: NSURL { return NSURL(string: "https://grove-api.herokuapp.com")! }

    var URL: NSURL {
        switch self {
        case .imagePost:
            return NSURL(string: "https://api.cloudinary.com/v1_1/whereno/image/upload")!
        default:
            return baseURL.URLByAppendingPathComponent(route.path)
        }
    }

    var route: (path: String, parameters: [String: AnyObject]) {
        switch self {
        case .commentsForLocation(let locationID):
            return ("/comment/\(locationID)", [:])
        case .locationFeed(let region):
            let lat = region.center.latitude
            let lon = region.center.longitude
            let latDelt = region.span.latitudeDelta
            let lonDelt = region.span.longitudeDelta
            return ("/feed", ["latitude": lat, "longitude": lon, "latitude_delta": latDelt, "longitude_delta": lonDelt])
        case .locationPost(let params):
            return ("/location", params)
        case .commentPost(let params):
            return ("/comment", params)
        case .imagePost(let imageData):
            return("", ["upload_preset": "a5txdosc", "file": imageData])
        }
    }

    var URLRequest: NSMutableURLRequest {
        let request: NSMutableURLRequest

        switch self {
        case .commentsForLocation, .locationFeed:
            request = Alamofire.ParameterEncoding.URLEncodedInURL
                .encode(NSURLRequest(URL: URL), parameters: route.parameters).0
        case .locationPost, .commentPost, .imagePost:
            request = Alamofire.ParameterEncoding.JSON
                .encode(NSURLRequest(URL: URL), parameters: route.parameters).0
            request.HTTPMethod = "POST"
        }

        request.setValue("Token token=\"\(User.authenticatedUser?.authToken ?? "")\"", forHTTPHeaderField: "Authorization")
        return request
    }
}
