//
//  AppDelegate.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

// TODO: Add network indicators
// TODO: Get more accurate location when adding

import UIKit
import RealmSwift
import AlamofireNetworkActivityIndicator
import JLRoutes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let loginNotification = "log_in"
    static let loginFailedNotification = "log_in_failed"

    let realm = try! Realm()

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UITabBar.appearance().tintColor = UIColor.dodgerBlue()
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        setUpRoutes()

        return true
    }

    // Handle 3D Touch shortcuts
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if let rootViewController = window?.rootViewController {
            if shortcutItem.type == "come.kylebashour.Whereno.AddLocation" {
                let vc = R.storyboard.compose.initialViewController()!
                rootViewController.presentViewController(vc, animated: false, completion: nil)
            }
        }
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {

        print(url)

        return JLRoutes.routeURL(url)
    }

    func setUpRoutes() {

        let signupPattern = "/signup"
        let loginPattern = "/login"

        JLRoutes.addRoutes([signupPattern, loginPattern]) { parameters -> Bool in

            if let user = User.from(parameters) {


                try! self.realm.write {
                    self.realm.delete(self.realm.objects(User))
                    self.realm.add(user)
                }

                let notification = NSNotification(name: AppDelegate.loginNotification, object: user)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
            else {
                let notification = NSNotification(name: AppDelegate.loginFailedNotification, object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }

            return true
        }
    }
}
