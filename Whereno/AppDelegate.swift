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
            [
                "id": 0,
                "title": "Grove by Hess",
                "latitude": 35.953119,
                "longitude": -83.9317127,
                "description": "Usually pretty nice, but sometimes there are smokers hanging out. Right next to a water fountain 💧",
                "image_url": "https://s-media-cache-ak0.pinimg.com/736x/62/c3/fc/62c3fc38e1a852ad4a12e0121e13ebf3.jpg",
                "comments": [
                    [
                        "id": 0,
                        "text": "Love it, great place for lots of people 👍",
                        "date": "2015-04-15T08:49:58.157+0000"
                    ],[
                        "id": 1,
                        "text": "Really great place! Bit loud during the school day, between 9AM-3PM, but pretty quiet after that. You can hear a water fountain, which it pretty relaxing :)",
                        "date": "2016-04-18T08:49:58.157+0000"
                    ]
                ]
            ],

            ["id": 1, "title": "Near Neyland", "latitude": 35.9555183, "longitude": -83.932715, "description": "Really fun to watch the crowds on game day!", "image_url": "https://www.eaglesnestoutfittersinc.com/wp-content/uploads/2014/03/indoor-e1363222403948.jpg"],
            ["id": 2, "title": "Nice Shade", "latitude": 35.9531734, "longitude": -83.9269893, "description": "Shade man, shade"],
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

