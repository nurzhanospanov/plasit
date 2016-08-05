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
    
    var arrayOfPlaces: [DisplayPlace] = []

    @IBOutlet weak var youveBeenToLabel: UILabel!
    
    @IBOutlet weak var beenToMetricsLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting text and font color for navbar
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
        self.beenHereMetrics()

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
                    self.arrayOfPlaces.append(place!)
                    
                    
                    place?.imagePlaceFile!.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if (error == nil) {
                            let image = UIImage(data: imageData!)
                            place?.imagePlace = image
                            self.tableView.reloadData()
                            self.beenHereMetrics()
                            
                        }
                    })

                }
            }
        } else {
            let alert = UIAlertController(title: "No places to display", message: "As you are not logged in, there are no places to display", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
    }
    
    func beenHereMetrics() {
        let beenMetrics = self.arrayOfPlaces.count
        if beenMetrics > 0 {
            self.beenToMetricsLabel.text = ("\(beenMetrics) places")
        } else {
            self.beenToMetricsLabel.text = "No Places yet"
        }
    }

}




extension UserBeenHereViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfPlaces.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("UserBeenHereCell") as! UserBeenHereTableViewCell
        cell.beenHereImageView.image = arrayOfPlaces[indexPath.row].imagePlace
        cell.beenHereTitle.text = arrayOfPlaces[indexPath.row].placeTitle
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