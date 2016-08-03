//
//  UserWantToGoViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/29/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UserWantToGoViewController: UIViewController {
    
    var arrayOfPlaces: [DisplayPlace] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var youWantToGoLabel: UILabel!
    
    @IBOutlet weak var wantToGoMetricsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        arrayOfPlaces = []
        self.tableView.reloadData()
        self.wantToGoMetrics()
        
        if let _ = PFUser.currentUser() {
            let query = PFQuery(className: "WantToGo")
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
                    self.arrayOfPlaces.append(place!)
                    
                    
                    place?.imagePlaceFile!.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if (error == nil) {
                            let image = UIImage(data: imageData!)
                            place?.imagePlace = image
                            self.tableView.reloadData()
                            self.wantToGoMetrics()
                            
                        }
                    })
                    
                }
            }
        } else {
            // handle case where no user is logged in
            print("")
        }
        
    }
    func wantToGoMetrics() {
        let wantToGoMetrics = self.arrayOfPlaces.count
        if wantToGoMetrics > 0 {
            self.wantToGoMetricsLabel.text = ("\(wantToGoMetrics) places")
        } else {
            self.wantToGoMetricsLabel.text = "No Places yet"
        }
    }
    
}





extension UserWantToGoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfPlaces.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserWantToGoCell") as! UserWantToGoTableViewCell
        
        cell.wantToGoImageView.image = arrayOfPlaces[indexPath.row].imagePlace
        cell.wantToGoTitle.text = arrayOfPlaces[indexPath.row].placeTitle
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("prepareForSegue: \(segue.identifier)")
        if let identifier = segue.identifier {
            if identifier == "displayPlacePost" {
                
                let indexPath = tableView.indexPathForSelectedRow!
                let place = arrayOfPlaces[indexPath.row]
                
                let placePostViewController = segue.destinationViewController as! PlacePostViewController
                
                placePostViewController.displayPlace = place
            }
        }
    }
}


