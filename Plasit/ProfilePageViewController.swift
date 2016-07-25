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
    
    
 
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("ProfilePageViewController - viewWillAppear")
        
        updateUI()

    }
    
    func updateUI () {
        
        if let userFirstName = PFUser.currentUser()?["firstName"] as? String {
            firstNameLabel.text = userFirstName
        } else {
            self.firstNameLabel.text = ""
        }
        
        if let userLastName = PFUser.currentUser()?["lastName"] as? String{
            lastNameLabel.text = userLastName
        } else {
            self.lastNameLabel.text = ""
        }
        
        if let userPicture = PFUser.currentUser()?["picture"] as? String,
            url = NSURL(string: userPicture),
            data = NSData(contentsOfURL: url),
            image = UIImage(data: data)
        {
            profilePictureImageView?.image = image
            
        }
        else {
            self.profilePictureImageView.image = nil
        }
    }
    
    
}

