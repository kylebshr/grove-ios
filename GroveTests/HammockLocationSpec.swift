//
//  HammockLocationSpec.swift
//  Grove
//
//  Created by Kyle Bashour on 5/21/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Quick
import Nimble
@testable import Grove

class HammockLocationSpec: QuickSpec {

    override func spec() {

        let id = "sdhad-2e98yhdw-location-id"
        let title = "Hammock Location Test"
        let descriptionText = "Location test description."
        let imageURLString = "https://image.com/image.jpg"
        let imageURL = NSURL(string: imageURLString)!
        let ownerID = "ytgd28d2-2d97g8ugbd2-owner-id"
        let date = NSDate()
        let dateString = NSDate.formatter.stringFromDate(date)
        let capacity = 8
        let latitude = 42.412
        let longitude = 124.214

        let json = [
            "id": id,
            "title": title,
            "description": descriptionText,
            "photo": imageURLString,
            "user_id": ownerID,
            "date_created": dateString,
            "capacity": capacity,
            "latitude": latitude,
            "longitude": longitude
        ]

        describe("HammockLocation") {

            var cut: HammockLocation!

            beforeEach {
                cut = HammockLocation.from(json)
            }

            describe("init") {
                it("should initialize all json properties") {
                    expect(cut.id) == id
                    expect(cut.title) == title
                    expect(cut.descriptionText) == descriptionText
                    expect(cut.imageURLString) == imageURLString
                    expect(cut.ownerID) == ownerID
                    expect(cut.date) == date
                    expect(cut.capacity) == capacity
                    expect(cut.latitude) == latitude
                    expect(cut.longitude) == longitude
                }
            }

            describe("computed properties") {
                it("should transform the image url string to a url") {
                    expect(cut.imageURL) == imageURL
                }
            }
        }
    }
}
