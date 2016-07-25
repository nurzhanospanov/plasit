//
//  LoginViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/22/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//

import Foundation
import UIKit
import Parse


class LoginPageViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            fetchProfile()
            
        }
    }
    
    func fetchProfile() {
        print("fetch profile")
        
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
                        // execute this if user already exists in Parse
                        
                        do
                        {
                            try PFUser.logInWithUsername(username, password: emailData)
                        }
                        catch
                        {
                            print(error)
                        }
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
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}


//            var currentUser = PFUser.currentUser()!.username
//
//            if  currentUser == nil {
//                user.signUpInBackgroundWithBlock() {(success, error) -> Void in
//                    if success {
//
//                        print("successfully saved")
//                    } else {
//                        // exectute this if user already exists in Parse
//                        PFUser.logInWithUsername(username, password: emailData)
//                }
//            }
//
//        }

//func checkUserCredentials() throws -> Bool {
//    try PFUser.logInWithUsername(username, password: emailData)
//
//    if (PFUser.currentUser() != nil) {
//        return true
//    }
//    return false
//}
