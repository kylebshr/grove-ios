//
//  HammockLocation.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import RealmSwift
import Mapper

final class HammockLocation: Object, Mappable {

    dynamic var id = 0
    dynamic var title = ""
    dynamic var descriptionText = ""
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0

    required convenience init(map: Mapper) throws {
        self.init()

        try id = map.from("id")
        try title = map.from("title")
        try descriptionText = map.from("description")
        try latitude = map.from("latitude")
        try longitude = map.from("longitude")
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
