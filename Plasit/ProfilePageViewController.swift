//
//  ProfilePageViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/14/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfilePageViewController: UITableViewController {

    
    @IBOutlet var profilePageTableView: UITableView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    
    
    
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
//        return cell
//        
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3 
//    }
}
