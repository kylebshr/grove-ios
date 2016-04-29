//
//  LocationComment.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import RealmSwift
import Mapper

final class LocationComment: Object, Mappable {


    // MARK: Static properties

    private static let commentFormatter: NSDateFormatter = {
        let formatter =  NSDateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()


    // MARK: Realm properties

    dynamic var id = ""
    dynamic var text = ""
    dynamic var ownerID = ""
    dynamic var date = NSDate()


    // MARK: Computed properties

    var formattedDate: String {
        return "Posted on " + LocationComment.commentFormatter.stringFromDate(date)
    }

    // Mapper initializer
    required convenience init(map: Mapper) throws {
        self.init()

        try id = map.from("id")
        try text = map.from("text")
        try date = map.from("date_created")
        try ownerID = map.from("user_id")
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
