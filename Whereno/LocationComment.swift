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

final class LocationComment: Object {

    dynamic var id = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}