//
//  Friend.swift
//  Grove
//
//  Created by Kyle Bashour on 5/9/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import RealmSwift
import Mapper

final class Friend: Object, Mappable {

    // MARK: Realm properties

    dynamic var id = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var profileImageURLString = ""
    let locations = List<HammockLocation>()

    var profileImageURL: NSURL {
        return NSURL(string: profileImageURLString)!
    }

    // Mapper initializer
    required convenience init(map: Mapper) throws {
        self.init()

        try id = map.from("id")
        try firstName = map.from("first_name")
        try lastName = map.from("last_name")
        try profileImageURLString = map.from("photo")

        let locations: [HammockLocation] = (try? map.from("locations")) ?? []
        self.locations.appendContentsOf(locations)
    }
}
