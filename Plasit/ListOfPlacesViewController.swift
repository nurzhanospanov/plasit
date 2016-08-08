//
//  ListOfPlaces.swift
//  Plasit
//
//  Created by nurzhan on 7/18/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse


class ListOfPlacesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var places: [DisplayPlace] = []
    var belongsToCategory: DisplayCategory?

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setting text for navbar
        self.title = "Places"
        //setting blue font for nav bar title
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 52.0/255, green: 152.0/255, blue: 219.0/255, alpha: 1.0)]
        
        let query = PFQuery(className: "Place")
        query.whereKey("belongsToCategory", equalTo: belongsToCategory!)
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) -> Void in
            
            self.places = result as? [DisplayPlace] ?? []
            // index is for proper counting of beenHere pointers
            var index = 0
            
            for place in self.places {
                // identifying which place we are dealing with for button release feature
                place.placeId = result![index].objectId
                
                place.imagePlaceFile?.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    let image = UIImage(data: imageData!, scale: 1.0)
                    place.imagePlace = image
                    self.tableView.reloadData()
                }
               // counting pins to places
                index = index + 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ListOfPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as! PlacesTableViewCell
        
        cell.placeImageView.image = places[indexPath.row].imagePlace
        cell.titleLabel.text = places[indexPath.row].placeTitle
        
        
        //set background color for cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView
    
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("user tapped cell at index path: \(indexPath)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // removing text from back button at next view controller
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        //setting blue font for nav bar title
        self.navigationController?.navigationBar.tintColor = UIColor(red: 52.0/255, green: 152.0/255, blue: 219.0/255, alpha: 1.0)
        
        if let identifier = segue.identifier {
            if identifier == "displayPlacePost" {
                
                let placePostViewController = segue.destinationViewController as! PlacePostViewController
                
                placePostViewController.displayPlace = places[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}



