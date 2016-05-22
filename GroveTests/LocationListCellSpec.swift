//
//  LocationCellSpec.swift
//  Grove
//
//  Created by Kyle Bashour on 5/21/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Quick
import Nimble
@testable import Grove

class LocationListCellSpec: QuickSpec {

    override func spec() {

        let id = "sdhad-2e98yhdw-location-id"
        let title = "Hammock Location Test"
        let descriptionText = "Location test description."
        let imageURLString = "https://image.com/image.jpg"
        let ownerID = "ytgd28d2-2d97g8ugbd2-owner-id"
        let realDate = NSDate()
        let dateString = NSDate.formatter.stringFromDate(realDate)
        let capacity = 8
        let latitude = 42.412
        let longitude = 124.214

        let json: NSDictionary = [
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

        let location = HammockLocation.from(json)!

        describe("LocationListCell") { 

            let cut = R.nib.locationListCell.firstView(owner: nil)!

            describe("init") {
                it("should load its views from the xib") {
                    expect(cut.largeImageView).toNot(beNil())
                    expect(cut.dimmingView).toNot(beNil())
                    expect(cut.titleLabel).toNot(beNil())
                }
            }

            describe("setting a location") {

                cut.configureForLocation(location)

                it("should set the title on the label") {
                    expect(cut.titleLabel.text) == title
                }
            }
        }
    }
}
