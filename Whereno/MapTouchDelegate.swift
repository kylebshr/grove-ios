//
//  MapTouchDelegate.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

protocol MapTouchDelegate: NSObjectProtocol {
    func updateTouches(touch: UITouch)
}
