//
//  UIAlertView+Extensions.swift
//  Grove
//
//  Created by Kyle Bashour on 5/3/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

extension UIAlertController {

    func presentOverKeyboard(animated: Bool, completion: (() -> Void)?) {

        /* 
         Create a window higher than the keyboard and use it to present self.
         The window is deallocated when the alert controller is, as we 
         declare it in an instance method. (I think that's why; regardless
         of why, I tested it out and I'm sure it's deallocated).
        */
        let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        alertWindow.rootViewController = whiteStatusBarVC()
        alertWindow.windowLevel = 10000001
        alertWindow.hidden = false
        alertWindow.tintColor = UIColor.dodgerBlue()
        alertWindow.rootViewController?.presentViewController(self, animated: animated, completion: completion)
    }
}

private class whiteStatusBarVC: UIViewController {
    private override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
