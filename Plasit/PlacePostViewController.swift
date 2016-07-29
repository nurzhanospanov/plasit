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
            print("called from function")
            animationForBeenHereButton()
            addBeenHerePlace()
        }
        else
        {
            beenHereButton.setImage(UIImage(named: "locationButton"), forState: .Normal)
            beenHereButtonPressed = false
            print("called from function")
            animationForBeenHereButton()
            deleteBeenHerePlace()
        }
        
    }
    
    @IBAction func wantToGoButtonPressed(sender: AnyObject) {
        
        if !wantToGoButtonPressed
        {
            wantToGoButton.setImage(UIImage(named: "airplaneButtonPressed"), forState: .Normal)
            wantToGoButtonPressed = true
            print("called from function wantToGo")
            animationForWantToGoButton()
            addWantToGoPlace()
        }
        else
        {
            wantToGoButton.setImage(UIImage(named: "airplaneButton"), forState: .Normal)
            wantToGoButtonPressed = false
            print("called from function wantToGo")
            animationForWantToGoButton()
            deleteWantToGoPlace()
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextView.textColor = UIColor.blackColor()
        
        let userQueryBeenHere = PFQuery(className: "BeenHere")
        
        if let user = PFUser.currentUser(),
            place = displayPlace {
            userQueryBeenHere.whereKey("fromUser", equalTo: user)
        
            userQueryBeenHere.whereKey("toPlace", equalTo: place)
            userQueryBeenHere.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results?.count > 0  {
                self.beenHereButton.setImage(UIImage(named: "locationButtonPressed"), forState: .Normal)
                    self.beenHereButtonPressed = true
                    print("pressed button called from viewDidLoad")
            
            } else {
                self.beenHereButton.setImage(UIImage(named: "locationButton"), forState: .Normal)
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
                    self.wantToGoButton.setImage(UIImage(named: "airplaneButtonPressed"), forState: .Normal)
                    self.wantToGoButtonPressed = true
                    print("pressed button called from viewDidLoad")
                    
                } else {
                    self.wantToGoButton.setImage(UIImage(named: "airplaneButton"), forState: .Normal)
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
            print("Hey where is User?")
            // make an alert here
        }
    }
    
    
    func deleteBeenHerePlace() {
    
        let query = PFQuery(className: "BeenHere")
        
        if let queryUser = PFUser.currentUser() {
            query.whereKey("fromUser", equalTo: queryUser)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                   object.deleteEventually()
                    
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
            print("Hey where is User?")
            // make an alert here
        }
    }
    
    
    func deleteWantToGoPlace() {
        
        let query = PFQuery(className: "WantToGo")
        
        if let queryUser = PFUser.currentUser() {
            query.whereKey("fromUser", equalTo: queryUser)
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    object.deleteInBackground()
                    
                    }
                }
            })
        }
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




