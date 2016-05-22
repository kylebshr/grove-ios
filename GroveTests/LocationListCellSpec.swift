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

        describe("LocationListCell") { 

            var cut: LocationListCell!

            describe("init") {
                cut = R.nib.locationListCell.firstView(owner: nil)!
                
            }

            describe("setting a location") {

            }
        }
    }
}
