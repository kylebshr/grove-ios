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
    @IBOutlet weak var tableView: UITableView!

    var originalImageHeight: CGFloat!
    var location: HammockLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        originalImageHeight = imageHeightConstraint.constant
        
        title = location.title
        tableView.contentInset = UIEdgeInsets(top: originalImageHeight, left: 0, bottom: 0, right: 0)
    }
}

extension LocationDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset =  -scrollView.contentOffset.y

        guard offset >= 0 else {
            return
        }

        imageHeightConstraint.constant = offset
    }
}

extension LocationDetailViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.comments.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.headerDescriptionCell)!
            cell.textLabel?.text = location.descriptionText
            return cell
        }

        return UITableViewCell()
    }
}
