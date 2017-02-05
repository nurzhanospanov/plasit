//
//  LoginViewController.swift
//  Plasit
//
//  Created by nurzhan on 7/15/16.
//  Copyright © 2016 Nurzhan. All rights reserved.
//


import UIKit
import Parse


class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        // Validate the text fields
        if username!.characters.count < 2 {

            
            let alertController = UIAlertController(title: "Invalid", message: "Username must be greater than 2 characters", preferredStyle: .Alert)
            let usernameAction = UIAlertAction(title: "Ok", style: .Default) {(action) in}
            alertController.addAction(usernameAction)
            self.presentViewController(alertController, animated: true) {}
            
        } else if password!.characters.count < 8 {

            let alertController = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: .Alert)
            let usernameAction = UIAlertAction(title: "Ok", style: .Default) {(action) in}
            alertController.addAction(usernameAction)
            self.presentViewController(alertController, animated: true) {}
            
        } else {
            // Run a spinner to show a task in progress
            //loader
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            spinner.center = self.view.center
            spinner.startAnimating()

            
            // Send a request to login
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {

                    
                    let alertController = UIAlertController(title: "Success", message: "Logged In", preferredStyle: .Alert)
                    let loginAction = UIAlertAction(title: "Ok", style: .Default) {(action) in
                        // sending user to profile page vc 
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    alertController.addAction(loginAction)
                    self.presentViewController(alertController, animated: true) {}
                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("profilePage") as! ProfilePageViewController
//                        let navController = UINavigationController(rootViewController: viewController)
//                        self.presentViewController(navController, animated: true, completion: nil)
//                    })
                    
                } else {
                    
                    let alertController = UIAlertController(title: "error", message: "\(error)", preferredStyle: .Alert)
                    let errorAction = UIAlertAction(title: "Ok", style: .Default) {(action) in}
                    alertController.addAction(errorAction)
                    self.presentViewController(alertController, animated: true) {}
                }
            })
        }
    }

}
