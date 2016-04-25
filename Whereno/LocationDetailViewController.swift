//
//  LocationDetailViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import Kingfisher

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageDimmingView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint! {
        didSet {
            originalHeaderHeight = imageHeightConstraint.constant
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsets(top: imageHeightConstraint.constant, left: 0, bottom: 0, right: 0)
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }

    var location: HammockLocation! {
        didSet {
            title = location.title
        }
    }
    var originalHeaderHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.kf_setImageWithURL(location.imageURL)
    }
}

extension LocationDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset =  -scrollView.contentOffset.y

        guard offset >= 0 else {
            return
        }

        imageDimmingView.alpha = 1 - (offset / originalHeaderHeight)
        imageHeightConstraint.constant = offset
    }
}

extension LocationDetailViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (location.comments.count == 0 ? 1 : location.comments.count) + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detailHeaderCell)!
            cell.descriptionLabel.text = location.descriptionText
            return cell
        }
        if indexPath.row == 1 && location.comments.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detailNoCommentsCell)!
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detailCommentCell)!
        let comment = location.comments[indexPath.row - 1]

        cell.commentLabel.text = comment.text
        cell.dateLabel.text = comment.formattedDate

        return cell
    }
}
