//
//  UIImage+Extensions.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/27/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

extension UIImage {

    func encode() -> String? {

        guard let imageData = UIImageJPEGRepresentation(self, 0.5) else {
            return nil
        }

        return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}
