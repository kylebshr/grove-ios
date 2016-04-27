//
//  LocationListViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController, UIViewControllerPreviewingDelegate {

    var locations: [HammockLocation]!

    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = false

        registerForPreviewingWithDelegate(self, sourceView: tableView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRowAtIndexPath($0, animated: true)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.locationListCell)!
        let location = locations[indexPath.row]

        cell.configureWithLocation(location)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let location = locations[indexPath.row]
        let vc = R.storyboard.map.locationDetailViewController()!

        vc.location = location

        navigationController?.pushViewController(vc, animated: true)
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRowAtPoint(location), cell = tableView.cellForRowAtIndexPath(indexPath) as? LocationListCell {

            previewingContext.sourceRect = cell.convertRect(cell.largeImageView.frame, toView: view)

            let vc = R.storyboard.map.locationDetailViewController()!
            vc.shouldShowTextInputView = false
            vc.location = locations[indexPath.row]
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
}
