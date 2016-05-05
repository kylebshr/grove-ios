//
//  AccountViewController.swift
//  Grove
//
//  Created by Kyle Bashour on 5/4/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let myLocationsHeaderID = "MyLocationsHeader"

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }

    func setUpTableView() {

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 24

        tableView.registerNib(R.nib.locationListCell)
        tableView.registerNib(R.nib.myLocationsHeader(), forHeaderFooterViewReuseIdentifier: myLocationsHeaderID)
    }
}

extension AccountViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello \(indexPath.row)"
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier(myLocationsHeaderID)
    }
}
