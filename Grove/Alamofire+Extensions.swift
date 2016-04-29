//
//  Alamofire+Extensions.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import Alamofire
import Mapper

extension Alamofire.Request {

    public func responseCollection<T: Mappable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in

            if let error = error { return .Failure(error) }

            let result = Alamofire.Request.JSONResponseSerializer(options: .AllowFragments)
                .serializeResponse(request, response, data, error)


            switch result {
            case .Success(let value):
                guard let jsonArray = value as? [[String: AnyObject]] else {
                    return .Failure(Error.errorWithCode(.JSONSerializationFailed,
                        failureReason: "JSON parsing error, JSON: \(value)"))
                }
                return .Success(jsonArray.flatMap { return T.from($0) })
            case .Failure(let error): return .Failure(error)
            }
        }

        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    public func responseObject<T: Mappable>(completionHandler: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in

            if let error = error { return .Failure(error) }

            let result = Alamofire.Request.JSONResponseSerializer(options: .AllowFragments)
                .serializeResponse(request, response, data, error)


            switch result {
            case .Success(let value):
                guard let dictValue = value as? NSDictionary, object = T.from(dictValue) else {
                    return .Failure(Error.errorWithCode(.JSONSerializationFailed,
                        failureReason: "JSON parsing error, JSON: \(value)"))
                }
                return .Success(object)
            case .Failure(let error): return .Failure(error)
            }
        }

        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    public func cloudinaryURL(completionHandler: Response<String, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<String, NSError> { request, response, data, error in

            if let error = error { return .Failure(error) }

            let result = Alamofire.Request.JSONResponseSerializer(options: .AllowFragments)
                .serializeResponse(request, response, data, error)


            switch result {
            case .Success(let value):
                guard let dictValue = value as? [String: AnyObject], url = dictValue["secure_url"] as? String else {
                    return .Failure(Error.errorWithCode(.JSONSerializationFailed,
                        failureReason: "JSON parsing error, JSON: \(value)"))
                }
                return .Success(url)
            case .Failure(let error): return .Failure(error)
            }
        }

        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

}
