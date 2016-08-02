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
    

    @IBOutlet var tapGestureRecognizerButton: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.delegate = self
        
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print("prepareForSegue: \(segue.identifier)")
//        if let identifier = segue.identifier {
//            if identifier == "displayPanoramaView" {
//                
//                let placePostViewController = segue.destinationViewController as! PlacePostViewController
//                placePostViewController.panorama = beenHereImageView.image
//            }
//        }
//    }

}



extension UserBeenHereViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserBeenHereCell") as! UserBeenHereTableViewCell
        
        cell.beenHereImageView.image = places[indexPath.row].imagePlace
        cell.beenHereTitle.text = places[indexPath.row].placeTitle
        
        tableView.allowsSelection = false
        cell.beenHereImageView.userInteractionEnabled = true
        
        let tappedOnImage = UITapGestureRecognizer(target: self, action: #selector(UserBeenHereViewController.tappedOnImage(_:)))
        cell.beenHereImageView.tag = indexPath.row
        cell.beenHereImageView.addGestureRecognizer(tappedOnImage)
        
        return cell
    }
    
    func tappedOnImage(sender: UIGestureRecognizer) {
        print("tapped cell ")
        self.performSegueWithIdentifier("displayPlacePost", sender: nil)
        
    }
}
