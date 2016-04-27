//
//  UIViewController+Extensions.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/27/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String?, message: String?, buttonTitle: String = "OK") {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .Cancel, handler: nil)

        alert.addAction(okButton)
        alert.view.tintColor = UIColor.dodgerBlue()

        presentViewController(alert, animated: true) {
            alert.view.tintColor = UIColor.dodgerBlue()
        }
    }
}