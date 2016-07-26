//
//  PlaceViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/19/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit


class PlacePostViewController: UITableViewController {
    

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




