//
//  SettingsViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 8/24/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func dismiss(sender: DismissButton) {
        sender.dismiss(self)
    }
    
    @IBOutlet var checkin: ShiftSegmentedControl?
    
    @IBAction func setCheckin(sender: ShiftSegmentedControl) {
        NSLog("setCheckin called")
        
        self.checkin!.setState(sender.selectedSegmentIndex)

        let currentUser = PFUser.currentUser()
        print(currentUser["checkin"])
        currentUser["checkin"] = sender.selectedSegmentIndex
        currentUser.save()
    }

    @IBAction func logout(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .Default) { (action) in
            PFUser.logOut()
            
            var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var loginController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("login") as UIViewController
            self.navigationController!.pushViewController(loginController, animated: false)
        }
        alertController.addAction(logOutAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }

    @IBAction func passwordReset(sender: AnyObject) {
        let alertController = UIAlertController(title: "Password Change", message: "Would you like to reset your password?", preferredStyle: .Alert)
        
        let resetAction = UIAlertAction(title: "Reset", style: .Default) { (action) in
            PFUser.requestPasswordResetForEmailInBackground(PFUser.currentUser().email)
            let confirmController = UIAlertController(title: "Password Reset", message: "A reset link has been sent to \(PFUser.currentUser().email).", preferredStyle: .Alert)
            confirmController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(confirmController, animated: true, completion: nil)
        }
        
        alertController.addAction(resetAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController!.navigationBar.barTintColor = ShiftColor.Orange.color()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
