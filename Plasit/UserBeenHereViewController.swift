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
    
    var placesOfArray: [DisplayPlace] = []
  //  var selectedRow: Int?

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self.placesOfArray.append(place!)
                    
                    
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



extension UserBeenHereViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placesOfArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("UserBeenHereCell") as! UserBeenHereTableViewCell
        cell.beenHereImageView.image = placesOfArray[indexPath.row].imagePlace
        cell.beenHereTitle.text = placesOfArray[indexPath.row].placeTitle
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("prepareForSegue: \(segue.identifier)")
        if let identifier = segue.identifier {
            if identifier == "displayPlacePost" {
                
                let indexPath = tableView.indexPathForSelectedRow!
                let place = placesOfArray[indexPath.row]
                
                let placePostViewController = segue.destinationViewController as! PlacePostViewController
                
                placePostViewController.displayPlace = place
            }
        }
    }
}