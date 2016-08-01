//
//  ProfilePageViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/14/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfilePageViewController: UITableViewController, FBSDKLoginButtonDelegate {

    
    @IBAction func userBeenHereButton(sender: AnyObject) {
    }
    
    @IBOutlet weak var userWantToGoButton: UIButton!
    
    @IBOutlet var profilePageTableView: UITableView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameLabel.text = ""
        self.lastNameLabel.text = ""
        self.profilePictureImageView?.image
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            fetchProfile()

        }
    }
    
    func fetchProfile() {
        print("func fetch profile was called")
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            var firstNameData = ""
            var lastNameData = ""
            var emailData = ""
            var pictureData = ""
            
            
            if let firstName = result.valueForKey("first_name") as?  String {
                print(firstName)
                firstNameData = firstName
                
            }
            
            if let lastName = result.valueForKey("last_name") as? String {
                print(lastName)
                lastNameData = lastName
            }
            
            if let email = result.valueForKey("email") as? String {
                print(email)
                emailData = email
            }
            
            if let picture = result.valueForKey("picture")as? NSDictionary,
                data = picture["data"] as? NSDictionary,
                url = data["url"] as? String {
                print(url)
                pictureData = url
            }
            
            
            let user = PFUser()
            let username = "\(firstNameData)_\(lastNameData)"
            
            
            user["firstName"] = firstNameData
            user["lastName"] = lastNameData
            user["email"] = emailData
            user["picture"] = pictureData
            user["username"] = username
            user["password"] = emailData
            
            
            let currentUser = PFUser.currentUser()?.username
            
            if  currentUser == nil {
                user.signUpInBackgroundWithBlock() {(success, error) -> Void in
                    if success {
                        print("successfully saved")
                    } else {
                        
                        do
                        {
                            try PFUser.logInWithUsername(username, password: emailData)
                        }
                        catch
                        {
                            print(error)
                        }
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.updateUI()
//                        })
                        self.updateUI()
                        print("profile should not be blank")
                    }
                }
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        print("complete login")
        fetchProfile()
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("successfully logged out")
        PFUser.logOut()
       
        self.firstNameLabel.text = ""
        self.lastNameLabel.text = ""
        self.profilePictureImageView?.image = UIImage(named: "user.png")
        

    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    
    
    func updateUI () {
        
        if let userFirstName = PFUser.currentUser()?["firstName"] as? String    {
            firstNameLabel.text = userFirstName
        } else {
            self.firstNameLabel.text = ""
        }
        
        if let userLastName = PFUser.currentUser()?["lastName"] as? String  {
            lastNameLabel.text = userLastName
        } else {
            self.lastNameLabel.text = ""
        }
        
        if let userPicture = PFUser.currentUser()?["picture"] as? String,
            url = NSURL(string: userPicture),
            data = NSData(contentsOfURL: url),
            image = UIImage(data: data)
        {
            profilePictureImageView?.image = image
            
        }
        else {
            self.profilePictureImageView.image = nil
        }
    }
}

