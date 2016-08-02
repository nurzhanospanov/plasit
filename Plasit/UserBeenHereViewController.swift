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
    var selectedRow: Int?


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
        
            tableView.allowsSelection = false
        cell.beenHereImageView.userInteractionEnabled = true
        
        let tappedOnImage = UITapGestureRecognizer(target: self, action: #selector(UserBeenHereViewController.tappedOnImage(_:)))
        cell.beenHereImageView.tag = indexPath.row
        cell.beenHereImageView.addGestureRecognizer(tappedOnImage)
        
        
      //  cell.tapRecognizer1.addTarget(self, action: "img_Click:")
      //  cell.img.gestureRecognizers = []
      //  cell.img.gestureRecognizers!.append(cell.tapRecognizer1)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    func tappedOnImage(sender: UITapGestureRecognizer) {
        print("tapped cell ")
        
        let view = sender.view; //cast pointer to the derived class if needed
        selectedRow = view?.tag
        self.performSegueWithIdentifier("displayPlacePost", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
       
        
        
       // let row = tableView.indexPathForSelectedRow?.row
       // let row = tableView.indexPathForCell(cell!)?.row
        let displayPlace = placesOfArray[selectedRow!]
        
        let placePostViewController = segue.destinationViewController as? PlacePostViewController
        placePostViewController?.displayPlace = displayPlace
    }
}
