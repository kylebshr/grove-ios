//
//  DetailCommentCell.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class DetailCommentCell: UITableViewCell {


    // MARK: Outlets

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!


    func configureForComment(comment: LocationComment) {
        dateLabel.text = comment.formattedDate
        commentLabel.text = comment.text
    }
}
