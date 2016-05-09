//
//  FriendsViewController.swift
//  Grove
//
//  Created by Kyle Bashour on 5/9/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsViewController: UITableViewController {


    // MARK: Properties

    let realm = try! Realm()

    lazy var friends: Results<Friend> = self.realm.objects(Friend)
    var token: NotificationToken?


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRealmNotification()
    }

    deinit {
        token?.stop()
    }


    // MARK: Helpers

    func setUpRealmNotification() {

        token = friends.addNotificationBlock { [unowned self] (changes: RealmCollectionChange) in

            switch changes {

            case .Initial:
                self.tableView.reloadData()

            case .Update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.endUpdates()

            case .Error(let error):
                log.error(error.localizedDescription)
            }
        }
    }


    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.friendCell)!
        cell.configureForFriend(friends[indexPath.row])
        return cell
    }
}
