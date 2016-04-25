//
//  LocationDetailViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    var originalImageHeight: CGFloat!
    var location: HammockLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        originalImageHeight = imageHeightConstraint.constant
        
        title = location.title
        scrollView.contentInset = UIEdgeInsets(top: originalImageHeight, left: 0, bottom: 0, right: 0)
        descriptionLabel.text = location.descriptionText
    }
}

extension LocationDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset =  -scrollView.contentOffset.y

        guard offset > 0 else {
            return
        }

        imageHeightConstraint.constant = offset
    }
}
