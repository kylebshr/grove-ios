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

    internal static let serviceName = "grove_service"
    internal static let account = "user_token"
    internal static let realm = try! Realm()

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
            if let newValue = newValue {
                SSKeychain.setPassword(newValue, forService: User.serviceName, account: User.account)
            }
            else {
                SSKeychain.deletePasswordForService(User.serviceName, account: User.account)
            }
        }
    }

    var profileImageURL: NSURL {
        return NSURL(string: profileImageURLString)!
    }

    // Mapper initializer
    required convenience init(map: Mapper) throws {
        self.init()

        logOut()

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
