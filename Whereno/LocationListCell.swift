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

    override func setSelected(selected: Bool, animated: Bool) {
        setTapped(selected, animated: animated)
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        setTapped(highlighted, animated: animated)
    }

    func setTapped(tapped: Bool, animated: Bool) {

        let duration = animated ? 0.33 : 0
        let color = tapped ? UIColor.blackColor().colorWithAlphaComponent(0.7) : UIColor.blackColor().colorWithAlphaComponent(0.5)

        UIView.animateWithDuration(duration) { 
            self.dimmingView.backgroundColor = color
        }
    }
}
