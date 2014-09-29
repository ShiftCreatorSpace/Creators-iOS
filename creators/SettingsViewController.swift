//
//  SettingsViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 8/24/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var loginController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("login") as UIViewController
        self.navigationController.pushViewController(loginController, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
