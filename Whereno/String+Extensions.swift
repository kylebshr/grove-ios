//
//  String+Extensions.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation

extension String {

    func stringByRemovingWhiteSpace() -> String {
        let components = self.componentsSeparatedByCharactersInSet(.whitespaceAndNewlineCharacterSet())
        return components.joinWithSeparator("")
    }
}
