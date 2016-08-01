//
//  UserBeenHereViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/29/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UserBeenHereViewController: UIViewController {
    
    var places: [DisplayPlace] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        
        if let _ = PFUser.currentUser() {
            let query = PFQuery(className: "BeenHere")
            query.includeKey("toPlace")
            query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if let actualError = error {
                    print("an error occured: \(actualError)")
                    return
                }
                
                for beenHere in objects! {
                    
                    let place = beenHere["toPlace"] as? DisplayPlace
                    let title = place?.placeTitle
                    print(title)
                    self.places.append(place!)
                    
                    
                    place?.imagePlaceFile!.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if (error == nil) {
                            let image = UIImage(data: imageData!)
                            place?.imagePlace = image
                            self.tableView.reloadData()
                            
                        }
                    })
                    
                }
            }
        }
        else {
            // handle case where no user is logged in
            print("")
        }
        
    }
}

extension UserBeenHereViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserBeenHereCell") as! UserBeenHereTableViewCell
        
        cell.beenHereImageView.image = places[indexPath.row].imagePlace
        cell.beenHereTitle.text = places[indexPath.row].placeTitle
        return cell
    }
}
