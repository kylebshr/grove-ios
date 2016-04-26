//
//  AddLocationViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class AddLocationViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.sourceType = .Camera
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        guard indexPath.row == 0 else { return }

        imageView.image == nil ? showCamera() : showPhotoOptions()
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
}
