//
//  ListOfCategoriesViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/14/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse


class ListOfCategoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindToListOfCategoriesViewController(segue: UIStoryboardSegue) {
        
        
    }
    
    var categories: [DisplayCategory] = []

    //    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let query = PFQuery(className: "Category")
        
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) -> Void in
            
            self.categories = result as? [DisplayCategory] ?? []
            print("received \(self.categories.count) categories from parse DB, now fetch individual images")
            
            for category in self.categories {
                print("fetch image for category: \(category.titleCategory)")
                
                category.imageCategoryFile?.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    
                    let image = UIImage(data: imageData!, scale: 1.0)
                    category.imageCategory = image
                    
                    print("received image for category: \(category.titleCategory)")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ListOfCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("create cell for row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoriesTableViewCell
        cell.categoryImageView.image = categories[indexPath.row].imageCategory
        
        return cell
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue: \(segue.identifier)")
        if let identifier = segue.identifier {
            if identifier == "displayListOfPlaces" {
                // print("Table view cell tapped")
                
                if let indexPath =  tableView.indexPathForSelectedRow {
                    let displayPlaces = categories[indexPath.row]
                    let displayListOfPlacesViewController = segue.destinationViewController as! ListOfPlacesViewController
                    displayListOfPlacesViewController.belongsToCategory = displayPlaces
                    
                }
                else {
                    print("there is no indexpath")
                    
                }
                
            }
            
        }
    }
}
