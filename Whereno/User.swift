//
//  User.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import RealmSwift
import Mapper

class User: Object, Mappable {

    dynamic var id = 0

    let favorites = List<HammockLocation>()

    override static func primaryKey() -> String? {
        return "id"
    }

    required convenience init(map: Mapper) throws {
        self.init()

        try id = map.from("id")
        try User.authToken = map.from("auth_token")
    }

    private static let authTokenKey = "defaults_auth_token"
    private static let defaults = NSUserDefaults.standardUserDefaults()
    private static let realm = try! Realm()

    static var authToken: String? {
        get {
            return defaults.stringForKey(authTokenKey)
        }
        set {
            defaults.setObject(newValue, forKey: authTokenKey)
        }
    }

    static var authenticatedUser: User? {
        guard authToken != nil else { return nil }
        return realm.objects(User).first
    }
}
