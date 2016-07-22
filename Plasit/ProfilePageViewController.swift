//
//  ProfilePageViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/14/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit

class ProfilePageViewController: UITableViewController {

    @IBOutlet var profilePageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
