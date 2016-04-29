//
//  JSONEncodable.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation

protocol JSONEncodable {
    func toJSON() -> [String: AnyObject]
}
