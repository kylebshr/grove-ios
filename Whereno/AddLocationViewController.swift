//
//  AddLocationViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class AddLocationViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionPlaceholder: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.sourceType = .Camera

        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
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

    func textViewDidChange(textView: UITextView) {
        descriptionPlaceholder.placeholder = textView.text == "" ? "Describe this location" : ""
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
