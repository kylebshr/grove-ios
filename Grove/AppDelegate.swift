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
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Login notification names
    static let loginNotification = "log_in"
    static let loginFailedNotification = "log_in_failed"

    let realm = try! Realm()

    var window: UIWindow?


    // Set up a few things
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UITabBar.appearance().tintColor = .zodiacBlue()
        UINavigationBar.appearance().barTintColor = .zodiacBarBlue()
        UINavigationBar.appearance().barStyle = .Black


        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        PKHUD.sharedHUD.dimsBackground = false

        setUpRoutes()
        setUpLogger()

        // Temporary (maybe) until I figure out a better way to delete deleted locations
        deleteOutDatedLocations()
        
        return true
    }

    // Handle 3D Touch shortcuts
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {

        // We only want to present if there's a user and a view controller to present on
        if let rootViewController = window?.rootViewController where User.authenticatedUser != nil {
            if shortcutItem.type == "come.kylebashour.Whereno.AddLocation" {

                log.debug("Presenting compose from 3D Touch action")

                let vc = R.storyboard.compose.initialViewController()!
                rootViewController.presentViewController(vc, animated: false, completion: nil)
            }
        }
    }

    func setUpLogger() {
        log.addDestination(ConsoleDestination())
        log.debug("Logging to console enabled")

//        let platform = SBPlatformDestination(appID: "", appSecret: "", encryptionKey: "")
//        log.addDestination(platform)
//        log.debug("Logging to cloud enabled")
    }

    // Handle routing (login)
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {

        log.debug("Handling openURL with JLRoutes")

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

                log.debug("Signed up or logged in a user")
            }
            else {
                let notification = NSNotification(name: AppDelegate.loginFailedNotification, object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)

                log.error("Received signup or login route, but failed to parse a valid user")
            }

            return true
        }
    }

    func deleteOutDatedLocations() {
        try! realm.write {
            self.realm.delete(self.realm.objects(HammockLocation))
            self.realm.delete(self.realm.objects(LocationComment))
        }
    }
}
