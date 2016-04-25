//
//  LocationDetailViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import Kingfisher

class LocationDetailViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {


    // MARK: Outlets

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageDimmingView: UIView!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!


    // MARK: Properties

    // Force unwrapped as R.swift ensures this view exists
    let textInputView = R.nib.textInputView.firstView(owner: nil)!

    // Implicitely unwrapped as they will be set before use (much like the outlets above)
    var location: HammockLocation!
    var originalHeaderHeight: CGFloat!

    override var inputAccessoryView: UIView? {
        return textInputView
    }


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Save this for setting insets even when the constant has changed
        originalHeaderHeight = imageHeightConstraint.constant

        // Start downloading the location image
        imageView.kf_setImageWithURL(location.imageURL)

        // Set up the table view
        tableView.contentInset = UIEdgeInsets(top: originalHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension

        // Configure the TextInputView action
        textInputView.addTarget(self, action: #selector(textInputViewSendTapped))

        title = location.title
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Listen for keyboard (and input accessory) changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    // MARK: Helper functions

    /* 
     Since we're not using a UITableViewController, we need to manually 
     set the content and scroll indicator insets for the keyboard height.
    */
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let height = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().height else {
            return
        }

        // We use height - 0.5 to hide the bottom separator
        tableView.contentInset = UIEdgeInsets(top: originalHeaderHeight, left: 0, bottom: height - 0.5, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
    }

    // The user tapped "Send" on the input text view
    @objc func textInputViewSendTapped() {
        print("Sending text to server!\n\(textInputView.text)")
        textInputView.text = ""
    }

    // Allows for the input accessory to work
    override func canBecomeFirstResponder() -> Bool {
        return true
    }


    // MARK: UIScrollViewDelegate

    func scrollViewDidScroll(scrollView: UIScrollView) {

        // Get the content offset, but positive
        let offset =  -scrollView.contentOffset.y

        // If it's less than 0, we don't need to do anything
        guard offset >= 0 else {
            return
        }

        // Set the dimming view alpha and height of the image view for parallax effect
        imageDimmingView.alpha = 1 - (offset / originalHeaderHeight)
        imageHeightConstraint.constant = offset
    }


    // MARK: UITableViewDataSource

    // One section for the description, one for comments
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // For the description
        if section == 0 {
            return 1
        }

        // Return at least 1, for the "No comments" cell
        return location.comments.count == 0 ? 1 : location.comments.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Section 0 is for the single description cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detailHeaderCell)!
            cell.descriptionLabel.text = location.descriptionText
            return cell
        }

        // We're not in section 0, and there are no comments — show the "No comments" cell
        if location.comments.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detailNoCommentsCell)!
        }

        // By now, we know we're loading comments
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detailCommentCell)!
        let comment = location.comments[indexPath.row]

        cell.commentLabel.text = comment.text
        cell.dateLabel.text = comment.formattedDate

        return cell
    }
}
