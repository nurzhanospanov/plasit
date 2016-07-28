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


class PlacePostViewController: UITableViewController {
    
    var beenHereButtonPressed = false
    var wantToGoButtonPressed = false
    
    var displayPlace: DisplayPlace? {
        
        didSet {
            
            // make sure IBOutles get instantiated before we access and initialize them bby calling the getter for self.view
            let _ = self.view
            
            // update UI (initialize IBOutlets)
            
            updateUI()
        }
    }
    
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
            beenHereButton.setImage(UIImage(named: "locationButtonPressed"), forState: .Normal)
            beenHereButtonPressed = true
            animationForBeenHereButton()
            addBeenHerePlace()
        }
        else
        {
            beenHereButton.setImage(UIImage(named: "locationButton"), forState: .Normal)
            beenHereButtonPressed = false
            animationForBeenHereButton()
            deleteBeenHerePlace()
        }
        
    }
    
    @IBAction func wantToGoButtonPressed(sender: AnyObject) {
        
        if !wantToGoButtonPressed
        {
            wantToGoButton.setImage(UIImage(named: "airplaneButtonPressed"), forState: .Normal)
            wantToGoButtonPressed = true
            animationForWantToGoButton()
            addWantToGoPlace()
        }
        else
        {
            wantToGoButton.setImage(UIImage(named: "airplaneButton"), forState: .Normal)
            wantToGoButtonPressed = false
            animationForWantToGoButton()
            deleteWantToGoPlace()
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.descriptionTextView.textColor = UIColor.blackColor()
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
            print("Hey where is User?")
            // make an alert here
        }
    }
    
    
    func deleteBeenHerePlace() {
    
        let query = PFQuery(className: "BeenHere")
        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                   object.deleteEventually()
                    
                }
                
            }
        })
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
            print("Hey where is User?")
            // make an alert here
        }
    }
    
    
    func deleteWantToGoPlace() {
        
        let query = PFQuery(className: "WantToGo")
        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    object.deleteEventually()
                    
                }
                
            }
        })
    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue: \(segue.identifier)")
        if let identifier = segue.identifier {
            if identifier == "displayPanoramaView" {
                
                let panoramaViewController = segue.destinationViewController as! PanoramaViewController
                panoramaViewController.panorama = placeImageView.image
            }
        }
    }
}




