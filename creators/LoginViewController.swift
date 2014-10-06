//
//  LoginViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/31/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, PFLogInViewControllerDelegate {
    
    var login: PFLogInViewController = PFLogInViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() != nil) {
            var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var tabBarController: UITabBarController = storyboard.instantiateViewControllerWithIdentifier("tabBar") as UITabBarController
            //self.navigationController!.popViewControllerAnimated(false)
            //self.navigationController!.pushViewController(tabBarController, animated: false)
            self.presentViewController(tabBarController, animated: false, completion: nil)
        } else {
            self.login.fields = PFLogInFields(PFLogInFieldsUsernameAndPassword.value | PFLogInFieldsLogInButton.value)
            self.login.delegate = self
            
            self.presentViewController(self.login, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(false, completion: nil)
        //self.presentViewController(self.login, animated: false, completion: nil)
    }
    
}