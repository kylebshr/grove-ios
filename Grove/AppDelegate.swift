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
import Alamofire
import AlamofireNetworkActivityIndicator
import JLRoutes
import PKHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Login notification names
    static let loginNotification = "log_in"
    static let loginFailedNotification = "log_in_failed"

    let realm = try! Realm()

    var window: UIWindow?


    // Set up a few things
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        PKHUD.sharedHUD.dimsBackground = false

        setUpRoutes()
        
        return true
    }

    // Handle 3D Touch shortcuts
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {

        // We only want to present if there's a user and a view controller to present on
        if let rootViewController = window?.rootViewController where User.authenticatedUser != nil {
            if shortcutItem.type == "come.kylebashour.Whereno.AddLocation" {
                let vc = R.storyboard.compose.initialViewController()!
                rootViewController.presentViewController(vc, animated: false, completion: nil)
            }
        }
    }

    // Handle routing (login)
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return JLRoutes.routeURL(url)
    }

    // Set up JLRoutes
    func setUpRoutes() {

        // Patterns are the same
        let signupPattern = "/signup/:id/:auth_token"
        let loginPattern = "/login/:id/:auth_token"

        // For now, we handle each pattern the same
        JLRoutes.addRoutes([signupPattern, loginPattern]) { parameters -> Bool in

            // If we can case the params as a user, save them exclusively and post the notification
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
