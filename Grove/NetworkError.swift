//
//  NetworkError.swift
//  Grove
//
//  Created by Kyle Bashour on 5/11/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation

enum NetworkError: String, ErrorType {

    case invalidJSON
    case failedToEncodeImage

    static func errorWithType(type: NetworkError) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: "Serialization Error: \(type)"]
        return NSError(domain: "com.kylebashour.Whereno", code: -1, userInfo: userInfo)
    }
}
