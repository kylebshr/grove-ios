//
//  User.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation

class User {

    private static let userIDKey = "defaults_user_id"
    private static let authTokenKey = "defaults_auth_token"
    private static let defaults = NSUserDefaults.standardUserDefaults()

    static var id: Int? {
        get {
            return defaults.objectForKey(userIDKey) as? Int
        }
        set {
            defaults.setObject(newValue, forKey: userIDKey)
        }
    }

    static var authToken: String? {
        get {
            return defaults.stringForKey(authTokenKey)
        }
        set {
            defaults.setObject(newValue, forKey: authTokenKey)
        }
    }
}
