//
//  PlaceViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/19/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse


class PlacePostViewController: UITableViewController, UINavigationControllerDelegate {
    
    var beenHereButtonPressed = false
    var wantToGoButtonPressed = false

    
    var displayPlace: DisplayPlace? {
        
        didSet {
            
            // make sure IBOutles get instantiated before we access and initialize them by calling the getter for self.view
            let _ = self.view
            
            // update UI (initialize IBOutlets)
            
            updateUI()
        }
    }
    
    
    
    @IBOutlet weak var iveBeenHereLabel: UILabel!
    
    @IBOutlet weak var iWantToGoLabel: UILabel!
    
    @IBOutlet var placePostTableView: UITableView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var beenHereButton: UIButton!
    @IBOutlet weak var wantToGoButton: UIButton!
    
    @IBAction func beenHereButtonPressed(sender: AnyObject)
    {
        if !beenHereButtonPressed
        {
            beenHereButton.setImage(UIImage(named: "beenHerePressed"), forState: .Normal)
            beenHereButtonPressed = true
            print("called from function")
            animationForBeenHereButton()
            addBeenHerePlace()
        }
        else
        {
            beenHereButton.setImage(UIImage(named: "beenHere"), forState: .Normal)
            beenHereButtonPressed = false
            print("called from function")
            animationForBeenHereButton()
            if let placeId = displayPlace?.placeId {
               deleteBeenHerePlace(placeId)
            }
        }
        
    }
    
    @IBAction func wantToGoButtonPressed(sender: AnyObject) {
        
        if !wantToGoButtonPressed
        {
            wantToGoButton.setImage(UIImage(named: "wantToGoPressed"), forState: .Normal)
            wantToGoButtonPressed = true
            print("called from function wantToGo")
            animationForWantToGoButton()
            addWantToGoPlace()
        }
        else
        {
            wantToGoButton.setImage(UIImage(named: "wantToGo"), forState: .Normal)
            wantToGoButtonPressed = false
            print("called from function wantToGo")
            animationForWantToGoButton()
            if let placeId = displayPlace?.placeId{
                deleteWantToGoPlace(placeId)
            }
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting text and font color for navbar
        self.title = displayPlace?.placeTitle
        
        //setting blue font for nav bar title
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 52.0/255, green: 152.0/255, blue: 219.0/255, alpha: 1.0)]
        
        //set color for font
        self.descriptionTextView.textColor = UIColor.blackColor()
        
        
        
        let userQueryBeenHere = PFQuery(className: "BeenHere")
        
        if let user = PFUser.currentUser(),
            place = displayPlace {
            userQueryBeenHere.whereKey("fromUser", equalTo: user)
        
            userQueryBeenHere.whereKey("toPlace", equalTo: place)
            userQueryBeenHere.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results?.count > 0  {
                self.beenHereButton.setImage(UIImage(named: "beenHerePressed"), forState: .Normal)
                    self.beenHereButtonPressed = true
                    print("pressed button called from viewDidLoad")
            
            } else {
                self.beenHereButton.setImage(UIImage(named: "beenHere"), forState: .Normal)
                self.beenHereButtonPressed = false
                print("release button called from viewDidLoad")
                }
            }
            
        }
        
        let userQueryWantToGo = PFQuery(className: "WantToGo")
        
        if let user = PFUser.currentUser(),
            place = displayPlace {
            userQueryWantToGo.whereKey("fromUser", equalTo: user)
            
            userQueryWantToGo.whereKey("toPlace", equalTo: place)
            userQueryWantToGo.findObjectsInBackgroundWithBlock { (results, error) -> Void in
                if results?.count > 0  {
                    self.wantToGoButton.setImage(UIImage(named: "wantToGoPressed"), forState: .Normal)
                    self.wantToGoButtonPressed = true
                    print("pressed button called from viewDidLoad")
                    
                } else {
                    self.wantToGoButton.setImage(UIImage(named: "wantToGo"), forState: .Normal)
                    self.wantToGoButtonPressed = false
                    print("release button called from viewDidLoad")
                }
            }
        }
    }
    
 
    
    func updateUI() {
        print("displayPlace has been set in PlacePostViewController to: \(displayPlace?.placeTitle)")
        self.placeImageView.image = displayPlace?.imagePlace
        self.descriptionTextView.text = displayPlace?.placeDescription
        self.titleLabel.text = displayPlace?.placeTitle
    }
    
    
    func animationForBeenHereButton() {
        beenHereButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
        
        
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.beenHereButton.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    
    func animationForWantToGoButton() {
        wantToGoButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
        
        
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.wantToGoButton.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    
   func addBeenHerePlace() {
        
        let addedBeenHere = PFObject(className: "BeenHere")
        if let currentUser = PFUser.currentUser(),
            currentPlace = displayPlace
            where FBSDKAccessToken.currentAccessToken() != nil {
            
            addedBeenHere.setObject(currentUser, forKey: "fromUser")
            addedBeenHere.setObject(currentPlace, forKey: "toPlace")
            addedBeenHere.saveInBackground()
            
            
        } else {
            let alert = UIAlertController(title: "Quick reminder :)", message: "If you want to store pinned places, please login first", preferredStyle: .Alert)
    
                alert.addAction(UIAlertAction(title: "Got it, thanks!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            }
    
    }

    
    
    func deleteBeenHerePlace(placeId: String) {

        let query = PFQuery(className: "BeenHere")
        
        if let queryUser = PFUser.currentUser() {
            query.whereKey("fromUser", equalTo: queryUser)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    let placeInfo = object.objectForKey("toPlace") as? PFObject
                    let place = placeInfo?.objectId
                    
                    if place == placeId {
                            //object.removeObjectForKey("fromUser")
                            //object.saveInBackground()
                            object.deleteInBackground()
                        }
                    }
                
                }
            })
        }
    }
    
    func addWantToGoPlace() {
        
        let addedWantToGo = PFObject(className: "WantToGo")
        if let currentUser = PFUser.currentUser(),
            currentPlace = displayPlace
            where FBSDKAccessToken.currentAccessToken() != nil {
            
            addedWantToGo.setObject(currentUser, forKey: "fromUser")
            addedWantToGo.setObject(currentPlace, forKey: "toPlace")
            addedWantToGo.saveInBackground()
            
            
        } else {
            let alert = UIAlertController(title: "Quick reminder :)", message: "If you want to store pinned places, please login first", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Got it, thanks!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func deleteWantToGoPlace(placeId: String) {
        
        let query = PFQuery(className: "WantToGo")
        
        if let queryUser = PFUser.currentUser() {
            query.whereKey("fromUser", equalTo: queryUser)
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    let placeInfo = object.objectForKey("toPlace") as? PFObject
                    let place = placeInfo?.objectId
                    
                    if place == placeId {
                      
                        object.deleteInBackground()
                    }
                    
                    }
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if let identifier = segue.identifier {
            if identifier == "displayPanoramaView" {
                
                let panoramaViewController = segue.destinationViewController as! PanoramaViewController
                panoramaViewController.panorama = placeImageView.image
            }
        }
    }
    
}

    


