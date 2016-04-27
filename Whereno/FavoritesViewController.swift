//
//  FavoritesViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesViewController: UITableViewController, UIViewControllerPreviewingDelegate {

    let favorites = User.authenticatedUser?.favorites

    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        registerForPreviewingWithDelegate(self, sourceView: tableView)
        clearsSelectionOnViewWillAppear = false

        token = favorites?.addNotificationBlock { [weak self] (_: RealmCollectionChange) in
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRowAtIndexPath($0, animated: true)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let count = favorites?.count where count > 1 {
            return count
        }

        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if favorites?.count == 0 || favorites == nil {
            return tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.noFavoritesCell)!
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.locationListCell)!

        if let location = favorites?[indexPath.row] {
            cell.configureWithLocation(location)
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let location = favorites?[indexPath.row] {
            let vc = R.storyboard.map.locationDetailViewController()!
            vc.location = location
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) as? LocationListCell,
            location = favorites?[indexPath.row] {

            previewingContext.sourceRect = cell.convertRect(cell.largeImageView.frame, toView: view)

            let vc = R.storyboard.map.locationDetailViewController()!
            vc.shouldShowTextInputView = false
            vc.location = location
            return vc
        }

        return nil
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {

        if let vc = viewControllerToCommit as? LocationDetailViewController {
            vc.shouldShowTextInputView = true
        }

        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }

    deinit {
        token?.stop()
    }
}
