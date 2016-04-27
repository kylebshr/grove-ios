//
//  AddLocationViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class AddLocationViewController: UITableViewController {


    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var descriptionPlaceholder: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!


    // MARK: Properties

    let picker = UIImagePickerController()
    let realm = try! Realm()

    var descriptionTextHeight: CGFloat = 0
    var userLocation: CLLocationCoordinate2D!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self

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

    @IBAction func postTapped(sender: UIBarButtonItem) {

        // Validate all the fields
        guard let photoData = imageView.image?.encode() else {
            showAlert("Please add a photo 🖼", message: nil)
            return
        }
        guard let title = titleTextField.text where title.stringByRemovingWhiteSpace() != "" else {
            showAlert("Please add a title 🏷", message: nil)
            return
        }
        guard let capacity = Int(capacityTextField.text ?? "") else {
            showAlert("Please enter how many people you think can nest here 🔢", message: nil)
            return
        }
        guard let description = descriptionTextView.text where description.stringByRemovingWhiteSpace() != "" else {
            showAlert("Please add a description 📝", message: nil)
            return
        }

        NetworkManager.sharedInstance.postLocation(title, capacity: capacity, description: description, photoData: photoData, latitude: userLocation.latitude, longitude: userLocation.longitude) { [weak self] result in

            switch result {
            case .Success(let location):

                try! self?.realm.write {
                    self?.realm.add(location)
                }

                self?.dismissViewControllerAnimated(true, completion: nil)

            case .Failure(let error):
                print(error)
                self?.showAlert("Oh No!", message: "We're having issues posting this location right now. Please try again later!")
            }
        }
    }


    // MARK: UITableViewDataSource/Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // Deselect the row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        // Show camera or make the appropiate field become first responder
        if indexPath.row == 0 {
            imageView.image == nil ? showCamera() : showPhotoOptions()
        }
        else if indexPath.row == 1 {
            titleTextField.becomeFirstResponder()
        }
        else if indexPath.row == 2 {
            capacityTextField.becomeFirstResponder()
        }
        else if indexPath.row == 3 {
            descriptionTextView.becomeFirstResponder()
        }
    }

    // Lets us use Auto Layout with static table view
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }


    // MARK: Helpers

    func showCamera() {

        // We'll check if they have a camera, and if not, let them pick from the gallery
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
            presentViewController(picker, animated: true, completion: nil)
        } else {
            picker.sourceType = .SavedPhotosAlbum
            presentViewController(picker, animated: true, completion: nil)
        }
    }

    // Shows an action sheet when the photo is tapped to delete or add a new photo
    func showPhotoOptions() {

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .Destructive) { [weak self] _ in
            self?.imageView.image = nil
        }
        let newPhotoAction = UIAlertAction(title: "Take a New Photo", style: .Default) { [weak self] _ in
            self?.showCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        actionSheet.addAction(deleteAction)
        actionSheet.addAction(newPhotoAction)
        actionSheet.addAction(cancelAction)

        presentViewController(actionSheet, animated: true, completion: nil)
    }
}

extension AddLocationViewController: UIImagePickerControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        // Set the image
        imageView.image = image

        // Dismiss the camera
        dismissViewControllerAnimated(true, completion: nil)

        titleTextField.becomeFirstResponder()
    }
}

extension AddLocationViewController: UINavigationControllerDelegate { }

extension AddLocationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.nextField?.becomeFirstResponder()

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
