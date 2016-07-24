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
    
    //var imageSmth: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userFirstName = PFUser.currentUser()!["firstName"] as? String
        firstNameLabel.text = userFirstName
        
        let userLastName = PFUser.currentUser()!["lastName"] as? String
        lastNameLabel.text = userLastName
        
        let userPicture = PFUser.currentUser()!["picture"] as? String
        print(userPicture)
        
        let url = NSURL(string: userPicture!) // force unwrapping!!
        
        let data = NSData(contentsOfURL: url!) // force unwrapping!
        
        let image = UIImage(data: data!) // force unwrapping!
        
        profilePictureImageView.image = image
        
    }
}

