//
//  LocationListCell.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import Kingfisher

class LocationListCell: UITableViewCell {

    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var dimmingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    func configureWithLocation(location: HammockLocation) {
        largeImageView.kf_setImageWithURL(location.imageURL, placeholderImage: nil)
        titleLabel.text = location.title
    }
}
