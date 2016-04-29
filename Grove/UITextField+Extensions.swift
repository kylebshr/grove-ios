//
//  UITextField+Extensions.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {

    // Allows us to easily make the next field the first responder in a long form (with shouldReturn)
    @IBOutlet var nextField: UIView? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UIView
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
