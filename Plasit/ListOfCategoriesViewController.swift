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
        
        let queryCategories = PFQuery(className: "Category")
        queryCategories.findObjectsInBackgroundWithBlock { (categories, error) in
            if error == nil {
                
                if let returnedCategories = categories {
                    
                    
                    for category in returnedCategories {
                        
                        
                        
//                          let image = category["image"] as! PFFile
//                       image.getDataInBackgroundWithBlock()
                    
                    }
                }
            }
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

        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell")!
        
        cell.textLabel!.text = "title"
        
        return cell
    }
}
