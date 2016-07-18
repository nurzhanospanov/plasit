//
//  DisplayPlace.swift
//  Plasit
//
//  Created by nurzhan on 7/18/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import Parse

class DisplayPlace: PFObject, PFSubclassing {
    
    @NSManaged var imagePlaceFile: PFFile?
    var imagePlace: UIImage?

    static func parseClassName() -> String {
        return "Place"
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
