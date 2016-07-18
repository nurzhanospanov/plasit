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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let query = PFQuery(className: "Place")
        
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

extension ListOfPlacesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       // print("create cell for row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell") as! PlaceTableViewCell
        
        cell.placeImageView.image = places[indexPath.row].imagePlace
        
        return cell
    }
    
}
