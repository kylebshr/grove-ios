//
//  AppDelegate.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let realm = try! Realm()

        let locations: [NSDictionary] = [
            ["id": 0, "title": "Nice place by hess", "latitude": 35.9538139, "longitude": -83.9305663, "description": "Usually pretty nice, but sometimes there are smokers hanging out."],
            ["id": 1, "title": "Near Neyland", "latitude": 35.9555183, "longitude": -83.9264314, "description": "Really fun to watch the crowds on game day!"],
            ["id": 2, "title": "Nice shade", "latitude": 35.9531734, "longitude": -83.9269893, "description": "Shade man, shade"],
        ]

        try! realm.write {
            locations.flatMap {
                return HammockLocation.from($0)
            }.forEach {
                realm.add($0, update: true)
            }
        }


        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

