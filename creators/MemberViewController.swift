//
//  MemberViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/26/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    var member = PFUser()
    @IBOutlet var firstName: UILabel
    @IBOutlet var lastName: UILabel
    @IBOutlet var major: UILabel
    @IBOutlet var phone: UILabel
    @IBOutlet var email: UILabel
    @IBOutlet var bio: UITextView
    @IBOutlet var selfie: UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        println(member)
        
        firstName.text = String(member["firstName"] as NSString)
        lastName.text = String(member["lastName"] as NSString)
        major.text = String(member["major"] as NSString)
        phone.text = toString(member["phone"] as NSNumber)
        email.text = String(member["email"] as NSString)
        bio.text = String(member["bio"] as NSString)
//        selfie.image =
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
