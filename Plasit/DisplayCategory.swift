//
//  Category.swift
//  Plasit
//
//  Created by nurzhan on 7/15/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import Parse

class DisplayCategory: PFObject, PFSubclassing {
    
    
    @NSManaged var image: PFFile?
    @NSManaged var title: String?
    
    static func parseClassName() -> String {
        return "Category"
    }
    
  
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}

