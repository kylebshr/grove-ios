//
//  MyLocationsHeader.swift
//  Grove
//
//  Created by Kyle Bashour on 5/4/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class MyLocationsHeader: UITableViewHeaderFooterView {

    private let separator = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()

        // This is annoying to to in IB (can't set height to 0.5)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        separator.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        separator.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        separator.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(0.5).active = true
        separator.backgroundColor = .separatorColor()
    }
}
