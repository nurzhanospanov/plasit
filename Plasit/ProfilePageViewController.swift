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
    

    @IBOutlet weak var loginParseButton: UIButton!
    
    
    @IBOutlet var profilePageTableView: UITableView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    static let firstNameNSUserDefaults = "FIRST_NAME"
    static let lastNameNSUserDefaults = "LAST_NAME"
    static let profilePictureNSUserDefaults = "PROFILE_PICTURE"
    
    
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
        
    }()
    
    
    override func viewDidLoad() {
        
        //loader started
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.center = self.view.center
        spinner.startAnimating()
        
        super.viewDidLoad()
        
        //setting text for navbar
        self.title = "Profile"
        
        //remove text from back button in next view controller
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.firstNameLabel.text = ""
        self.profilePictureImageView?.image
       
        
        // rounding profile picture fetched from FB
        
        profilePictureImageView.layer.borderWidth = 1
        profilePictureImageView.layer.masksToBounds = false
        profilePictureImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height/2
        profilePictureImageView.clipsToBounds = true
        
        // adding facebook login button
        view.addSubview(loginButton)
        loginButton.center.x = view.center.x
        loginButton.frame = CGRectMake(loginButton.frame.origin.x, 130, 160, 20)

        loginButton.delegate = self
        
        // rounding login with parse button
        loginParseButton.layer.cornerRadius = 5
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            fetchProfile()
            
        // stop loader
        spinner.stopAnimating()
            
        }
        nsUserDefaults()
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //setting blue font for nav bar title
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 52.0/255, green: 152.0/255, blue: 219.0/255, alpha: 1.0)]
        
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

                        self.updateUI()
                        print("profile should not be blank")
                        
                    }
                }
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        fetchProfile()
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        PFUser.logOut()
        
        self.firstNameLabel.text = ""
        self.profilePictureImageView?.image = UIImage(named: "userPlaceholder.png")
        
        let alert = UIAlertController(title: "Success!", message: "You are logget out", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        
        
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    
    func updateUI () {
        
        if let userFirstName = PFUser.currentUser()?["firstName"] as? String    {
            firstNameLabel.text = userFirstName
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(firstNameLabel.text, forKey: ProfilePageViewController.firstNameNSUserDefaults)
        } else {
            self.firstNameLabel.text = ""
        }
        

        
        if let userPicture = PFUser.currentUser()?["picture"] as? String,
            url = NSURL(string: userPicture),
            data = NSData(contentsOfURL: url),
            image = UIImage(data: data)
        {
            profilePictureImageView?.image = image
            let prefs = NSUserDefaults.standardUserDefaults()
            let imageData = UIImageJPEGRepresentation(image, 100)
            prefs.setObject(imageData, forKey: ProfilePageViewController.profilePictureNSUserDefaults)
            
        }
        else {
            self.profilePictureImageView.image = nil
        }
    }
    
    func nsUserDefaults(){
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let _ = PFUser.currentUser() {
        if let firstNameData = prefs.stringForKey(ProfilePageViewController.firstNameNSUserDefaults) {
            firstNameLabel.text = firstNameData
        }

        
        if let imageData = prefs.objectForKey(ProfilePageViewController.profilePictureNSUserDefaults) as? NSData {
            
            let storedImage = UIImage.init(data: imageData)
            profilePictureImageView.image = storedImage
            }
        }
        else {
            firstNameLabel.text = ""
//            lastNameLabel.text = ""
            profilePictureImageView.image = UIImage(named: "userPlaceholder.png")
        
        }
    }
}

