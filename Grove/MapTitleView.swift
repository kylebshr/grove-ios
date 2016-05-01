//
//  MapTitleView.swift
//  Grove
//
//  Created by Kyle Bashour on 4/30/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import Async

class MapTitleView: UIView {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var compactTitleHeightConstraint: NSLayoutConstraint!

    override var tintColor: UIColor! {
        get {
            return titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
            subTitleLabel.textColor = newValue
        }
    }

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        subTitleLabel.text = ""
    }

    func showSubTitleWithText(text: String) {

        self.subTitleLabel.text = text

        UIView.animateWithDuration(0.33, delay: 0.1, options: [],
            animations: {
                self.subTitleLabel.alpha = 1
            },
            completion: nil
        )

        UIView.animateWithDuration(0.33) {
            self.titleHeightConstraint.active = false
            self.compactTitleHeightConstraint.active = true
            self.layoutIfNeeded()
        }
    }

    func hideSubTitle() {

        Async.main(after: 0.5) {

            UIView.animateWithDuration(0.33, delay: 0.1, options: [],
                animations: {
                    self.subTitleLabel.alpha = 0
                    self.compactTitleHeightConstraint.active = false
                    self.titleHeightConstraint.active = true
                    self.layoutIfNeeded()
                },
                completion: { _ in
                    self.subTitleLabel.text = ""
                }
            )
        }
    }
}
