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

        guard let imageData = UIImagePNGRepresentation(self) else {
            return nil
        }

        return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}
