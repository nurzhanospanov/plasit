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
        
        self.title = ""
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //setting blue font for nav bar title
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 52.0/255, green: 152.0/255, blue: 219.0/255, alpha: 1.0)]
        
        //setting blue font for nav bar title
        self.navigationController?.navigationBar.tintColor = UIColor(red: 52.0/255, green: 152.0/255, blue: 219.0/255, alpha: 1.0)
        
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
            let alert = UIAlertController(title: "No places to display", message: "You are either not logged in or haven't yet added any places", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
        
        // set background color for cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // removing text from back button at next view controller
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
     
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


