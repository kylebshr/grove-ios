//
//  LocationListViewController.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/26/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController {

    var locations: [HammockLocation]!

    override func viewDidLoad() {
        super.viewDidLoad()

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
}
