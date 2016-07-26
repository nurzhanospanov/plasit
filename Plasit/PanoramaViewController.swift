//
//  PanoramaViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/26/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation

class PanoramaViewController: UIViewController {
    var panorama: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let motionView:PanoramaView = PanoramaView(frame: self.view.bounds)
        motionView.setImage(panorama!)
        self.view.addSubview(motionView)
    }
}