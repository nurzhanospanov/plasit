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
    
    var categories: [DisplayCategory] = []
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        let query = PFQuery(className: "Category") //PFQuery.orQueryWithSubqueries ([titleQuery, imageQuery])
        
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) -> Void in

            self.categories = result as? [DisplayCategory] ?? []
            print("received \(self.categories.count) categories from parse DB, now fetch individual images")

            for category in self.categories {
                print("fetch image for category: \(category.title)")
                category.imageCategory?.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    let image = UIImage(data: imageData!, scale: 1.0)
                    category.imageSmth = image
                    
                    print("received image for category: \(category.title)")
                    self.tableView.reloadData()

                }

                
            }
            
            print("reload table view data")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension ListOfCategoriesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        print("create cell for row: \(indexPath.row)")

        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryTableViewCell
        
        cell.categoryImageView.image = categories[indexPath.row].imageSmth
        
        return cell
    }

}
