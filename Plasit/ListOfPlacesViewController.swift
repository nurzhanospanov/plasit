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
        
        
        let query = PFQuery(className: "Place")
        
        query.whereKey("belongsToCategory", equalTo: belongsToCategory!)
        
        //        query.includeKey("belongsToCategory")
        
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) -> Void in
            
            self.places = result as? [DisplayPlace] ?? []
            // print("received \(self.places.count) categories from parse DB, now fetch individual images")
            
            for place in self.places {
                // print("fetch image for category: \(category.titleCategory)")
                
                place.imagePlaceFile?.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    let image = UIImage(data: imageData!, scale: 1.0)
                    
                    place.imagePlace = image
                    
                    
                    
                    //    print("received image for category: \(category.titleCategory)")
                    self.tableView.reloadData()
                }
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
        
        // print("create cell for row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as! PlacesTableViewCell
        
        cell.placeImageView.image = places[indexPath.row].imagePlace
        cell.titleLabel.text = places[indexPath.row].placeTitle
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("user tapped cell at index path: \(indexPath)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue: \(segue.identifier)")
        if let identifier = segue.identifier {
            if identifier == "displayPlacePost" {
                
                let placePostViewController = segue.destinationViewController as! PlacePostViewController
                placePostViewController.placeImage = places[0].imagePlace
            }
            
        }
        
    }
}



