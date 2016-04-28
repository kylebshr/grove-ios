//
//  AppDelegate.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/24/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UITabBar.appearance().tintColor = UIColor.dodgerBlue()
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true

        let realm = try! Realm()

        let locations: [NSDictionary] = [
            [
                "id": "0",
                "title": "Grove by Hess",
                "latitude": 35.953119,
                "longitude": -83.9317127,
                "description": "Usually pretty nice, but sometimes there are smokers hanging out. Right next to a water fountain 💧",
                "image_url": "https://s-media-cache-ak0.pinimg.com/736x/62/c3/fc/62c3fc38e1a852ad4a12e0121e13ebf3.jpg",
                "comments": [
                    [
                        "id": "0",
                        "text": "Love it, great place for lots of people 👍",
                        "date": "2016-04-15T08:49:58.157+0000",
                        "user_id": "0"
                    ],[
                        "id": "1",
                        "text": "Really great place! Bit loud during the school day, between 9AM-3PM, but pretty quiet after that. You can hear a water fountain, which is pretty relaxing.",
                        "date": "2016-04-18T08:49:58.157+0000",
                        "user_id": "0"
                    ]
                ],
                "user_id": "0"
            ],

            ["id": "1", "title": "Near Neyland", "latitude": 35.9535183, "longitude": -83.912715, "description": "Really fun to watch the crowds on game day!", "image_url": "https://www.eaglesnestoutfittersinc.com/wp-content/uploads/2014/03/indoor-e1363222403948.jpg", "user_id": "0"],
            ["id": "3", "title": "Near Neyland", "latitude": 35.9595183, "longitude": -83.939715, "description": "Really fun to watch the crowds on game day!", "image_url": "https://www.eaglesnestoutfittersinc.com/wp-content/uploads/2014/03/indoor-e1363222403948.jpg", "user_id": "1"],
            ["id": "4", "title": "Near Neyland", "latitude": 35.9155183, "longitude": -83.942715, "description": "Really fun to watch the crowds on game day!", "image_url": "https://www.eaglesnestoutfittersinc.com/wp-content/uploads/2014/03/indoor-e1363222403948.jpg", "user_id": "0"],
            ["id": "5", "title": "Near Neyland", "latitude": 35.9555183, "longitude": -83.932715, "description": "Really fun to watch the crowds on game day!", "image_url": "https://www.eaglesnestoutfittersinc.com/wp-content/uploads/2014/03/indoor-e1363222403948.jpg", "user_id": "0"],
            [
                "id": "2",
                "title": "Nice Shade",
                "latitude": 35.9531734,
                "longitude": -83.9269893,
                "description": "Shade man, shade",
                "image_url": "https://s-media-cache-ak0.pinimg.com/736x/62/c3/fc/62c3fc38e1a852ad4a12e0121e13ebf3.jpg",
                "comments": [
                    [
                        "id": "3",
                        "text": "Nice and breezy",
                        "date": "2016-04-15T08:49:58.157+0000",
                        "user_id": "0"
                    ],[
                        "id": "4",
                        "text": "Really great place! Bit loud during the school day, between 9AM-3PM, but pretty quiet after that. You can hear a water fountain, which is pretty relaxing.",
                        "date": "2016-04-18T08:49:58.157+0000",
                        "user_id": "0"
                    ],[
                        "id": "5",
                        "text": "👍",
                        "date": "2016-04-18T08:49:58.157+0000",
                        "user_id": "0"
                    ],[
                        "id": "6",
                        "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                        "date": "2016-04-18T08:49:58.157+0000",
                        "user_id": "0"
                    ],[
                        "id": "7",
                        "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        "date": "2016-04-18T08:49:58.157+0000",
                        "user_id": "0"
                    ],[
                        "id": "6",
                        "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                        "date": "2016-04-18T08:49:58.157+0000",
                        "user_id": "0"
                    ]
                ],
                "user_id": "0"
            ],
        ]

        let user = User.from(["id": "0", "auth_token": "123"])!

        try! realm.write {

            if User.authenticatedUser == nil { realm.add(user, update: true) }
            locations.flatMap {
                return HammockLocation.from($0)
            }.forEach {
                realm.add($0, update: true)
            }
        }


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
}
