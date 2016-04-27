//
//  AddLocationViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class AddLocationViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionPlaceholder: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!


    // MARK: Properties

    let picker = UIImagePickerController()

    var descriptionTextHeight: CGFloat = 0


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.sourceType = .Camera

        // Line up the text view with the placeholder text field
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
    }


    // MARK: IBActions

    @IBAction func cancelTapped(sender: UIBarButtonItem) {

        // dismiss the keyboard with the vc
        view.endEditing(true)

        // get outta here!
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row == 0 {
            imageView.image == nil ? showCamera() : showPhotoOptions()
        }
        else if indexPath.row == 1 {
            titleTextField.becomeFirstResponder()
        }
        else if indexPath.row == 2 {
            descriptionTextView.becomeFirstResponder()
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func showCamera() {
        presentViewController(picker, animated: true, completion: nil)
    }

    func showPhotoOptions() {

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .Destructive) { [weak self] _ in
            self?.imageView.image = nil
        }
        let newPhotoAction = UIAlertAction(title: "Take a New Photo", style: .Default) { [weak self] _ in
            self?.showCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        actionSheet.addAction(newPhotoAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)

        presentViewController(actionSheet, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === titleTextField {
            descriptionTextView.becomeFirstResponder()
        }

        return true
    }
}

extension AddLocationViewController: UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {

        // Hide or show the placeholder
        descriptionPlaceholder.placeholder = textView.text == "" ? "Describe this location" : ""

        /*
         Animate the table view growing for the description text view.

         The beginUpdates/endUpdates causes the table view to glitch to the top,
         so we only do it if the height has actually changed.
         */
        let newHeight = descriptionTextView.intrinsicContentSize().height
        if newHeight != descriptionTextHeight {
            descriptionTextHeight = newHeight
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
