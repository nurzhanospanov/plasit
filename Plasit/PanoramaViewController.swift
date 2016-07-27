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
    var motionView: PanoramaView!
    
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionView = PanoramaView(frame: self.view.bounds)
        motionView.setImage(panorama!)
        self.view.addSubview(motionView)
        self.view.bringSubviewToFront(backButton)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        motionView.removeObservers()
    }
    
    
    func backButton(sender: AnyObject) {
        print("back button pressed")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

