//
//  UserSpec.swift
//  Grove
//
//  Created by Kyle Bashour on 5/22/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Quick
import Nimble
import Mapper
import RealmSwift
import SSKeychain
@testable import Grove

class UserSpec: QuickSpec {

    override func spec() {

        let id = "918djd8-2d98h12d-user-id"
        let authToken = "0e912jj-23dhdh19d12d-auth-token"
        let firstName = "John"
        let lastName = "Appleseed"
        let profileImageURLString = "https://image.com/image.jpg"
        let profileImageURL = NSURL(string: profileImageURLString)!

        let json = [
            "id": id,
            "auth_token": authToken,
            "first_name": firstName,
            "last_name": lastName,
            "photo": profileImageURLString
        ]

        describe("User") { 

            var cut: User!

            beforeEach {
                cut = User.from(json)
            }

            describe("init") {
                it("should map all properties") {
                    expect(cut.id) == id
                    expect(cut.firstName) == firstName
                    expect(cut.lastName) == lastName
                    expect(cut.profileImageURLString) == profileImageURLString
                }
            }

            describe("computed properties") {
                it("should save the authtoken") {
                    expect(cut.authToken) == authToken
                }
                it("should transform the image url string to a url") {
                    expect(cut.profileImageURL) == profileImageURL
                }
            }

            describe("realm tests") {

                let realm = try! Realm()

                beforeEach {
                    try! realm.write {
                        realm.deleteAll()
                        realm.add(cut)
                    }
                }

                it("should get a valid user") {
                    expect(User.authenticatedUser).toNot(beNil())
                }

                it("should delete the user on logout") {
                    cut.logOut()
                    expect(User.authenticatedUser).to(beNil())
                }

                it("should delete the auth token on logout") {
                    cut.logOut()
                    let token = SSKeychain.passwordForService(User.serviceName, account: User.account)
                    expect(token).to(beNil())
                }

                it("should only allow one user object to be saved") {

                    var newJSON = json
                    newJSON["id"] = "other_id"
                    let newUser = User.from(newJSON)!
                    try! realm.write {
                        realm.add(newUser)
                    }

                    expect(realm.objects(User).count) == 1
                }
            }
        }
    }
}
