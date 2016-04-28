//
//  DetailHeaderCell.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class DetailHeaderCell: UITableViewCell {

    private static let capacityFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .SpellOutStyle
        return formatter
    }()

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!

    func configureForLocation(location: HammockLocation) {
        descriptionLabel.text = location.descriptionText

        if let capacity = DetailHeaderCell.capacityFormatter
            .stringFromNumber(NSNumber(integer: location.capacity)) {
            capacityLabel.text = "About \(capacity) \(location.capacity == 1 ? "person" : "people") can nest here"
        }
    }
}
