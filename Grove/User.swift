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
import SSKeychain

final class User: Object, Mappable {


    // MARK: Static properties

    private static let serviceName = "grove_service"
    private static let account = "user_token"
    private static let realm = try! Realm()

    static var authenticatedUser: User? {
        let user = realm.objects(User).first
        guard user?.authToken != nil else { return nil }
        return user
    }


    // MARK: Realm properties

    dynamic var id = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var profileImageURLString = ""
    let favorites = List<HammockLocation>()

    
    // MARK: Computed properties

    var authToken: String? {
        get {
            return SSKeychain.passwordForService(User.serviceName, account: User.account)
        }
        set {
            SSKeychain.setPassword(newValue, forService: User.serviceName, account: User.account)
        }
    }

    var profileImageURL: NSURL {
        return NSURL(string: profileImageURLString)!
    }

    // Mapper initializer
    required convenience init(map: Mapper) throws {
        self.init()

        authToken = nil

        try id = map.from("id")
        try authToken = map.from("auth_token")
        try firstName = map.from("first_name")
        try lastName = map.from("last_name")
        try profileImageURLString = map.from("photo")
    }

    // remove the auth token and delete any user objects
    func logOut() {

        authToken = nil

        try! User.realm.write {
            User.realm.delete(User.realm.objects(User))
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
