//
//  LocationListViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController {


    // MARK: Properties

    var locations: [HammockLocation]!


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // UITableViewController implementation of this is buggy
        clearsSelectionOnViewWillAppear = false

        // Register for cell 3D Touch
        registerForPreviewingWithDelegate(self, sourceView: tableView)

        // Set up cells
        setUpTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Animates interactively on swipeback
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRowAtIndexPath($0, animated: animated)
        }
    }


    // MARK: Helpers

    func setUpTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 124
        tableView.registerNib(R.nib.locationListCell)
    }

    func viewControllerForLocation(location: HammockLocation) -> LocationDetailViewController {
        let vc = R.storyboard.map.locationDetailViewController()!
        vc.location = location
        return vc
    }

    // MARK: UITableViewDataSource/Delegate

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Deque a cell and configure with a location
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.locationListCell)!
        let location = locations[indexPath.row]
        cell.configureForLocation(location)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(viewControllerForLocation(locations[indexPath.row]), animated: true)
    }
}

extension LocationListViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRowAtPoint(location), cell = tableView.cellForRowAtIndexPath(indexPath) as? LocationListCell {

            // We only want the rect of the image, not the white separator too!
            previewingContext.sourceRect = cell.convertRect(cell.largeImageView.frame, toView: view)

            let vc = viewControllerForLocation(locations[indexPath.row])
            vc.shouldShowTextInputView = false
            return vc
        }

        return nil
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {

        // Make sure we set this to true, as it was set to false for previewing
        if let vc = viewControllerToCommit as? LocationDetailViewController {
            vc.shouldShowTextInputView = true
        }

        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
