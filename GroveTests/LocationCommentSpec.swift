//
//  LocationCommentSpec.swift
//  Grove
//
//  Created by Kyle Bashour on 5/21/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Quick
import Nimble
import Mapper
@testable import Grove

class LocationCommentSpec: QuickSpec {

    override func spec() {

        let id = "sdhad-2e98yhdw-comment-id"
        let text = "Hammock Location Comment Test 👍"
        let ownerID = "ytgd28d2-2d97g8ugbd2-owner-id"
        let realDate = NSDate(timeIntervalSince1970: 1463879237)
        let dateString = NSDate.formatter.stringFromDate(realDate)
        let formattedDateString = "Posted on May 21, 2016"
        let date = NSDate.formatter.dateFromString(dateString)!

        let json = [
            "id": id,
            "text": text,
            "user_id": ownerID,
            "date_created": dateString,
        ]

        describe("LocationComment") {

            var cut: LocationComment!

            beforeEach {
                cut = LocationComment.from(json)!
            }

            describe("init") {
                it("should initialize all json properties") {
                    expect(cut.id) == id
                    expect(cut.text) == text
                    expect(cut.ownerID) == ownerID
                    expect(cut.date) == date
                }
            }

            describe("computed properties") {
                it("should format the date properly") {
                    expect(cut.formattedDate) == formattedDateString
                }
            }
        }
    }
}
