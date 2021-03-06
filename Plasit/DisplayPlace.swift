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
    @NSManaged var placeTitle: String
    @NSManaged var placeDescription: String
    // as objectId created by parse is not reachable we duplicate it with placeId variable
    @NSManaged var placeId: String?
    
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
