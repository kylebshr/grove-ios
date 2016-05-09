//
//  FriendCell.swift
//  Grove
//
//  Created by Kyle Bashour on 5/8/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationCountLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
}
