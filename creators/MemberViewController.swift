//
//  MemberViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/26/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit
import MessageUI

class MemberViewController: UIViewController {
//class MemberViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var member = PFUser()
    var image = UIImage()
    @IBOutlet var firstName: UILabel?
    @IBOutlet var lastName: UILabel?
    @IBOutlet var major: UILabel?
    @IBOutlet var phone: UILabel?
    @IBOutlet var email: UILabel?
    @IBOutlet var bio: UITextView?
    @IBOutlet var selfie: UIImageView?
    
//    var mc: MFMessageComposeViewController = MFMessageComposeViewController()
//    mc.messageComposeDelegate = self
    //mc.setSubject(emailTitle)
    //mc.setMessageBody(messageBody, isHTML: false)
    //mc.setToRecipients(toRecipents)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = ShiftColor.Orange.color()
        
        // Do any additional setup after loading the view, typically from a nib.
        firstName!.text = String(member["firstName"] as NSString)
        lastName!.text = String(member["lastName"] as NSString)
        major!.text = String(member["major"] as NSString)
        phone!.text = toString(member["phone"] as NSNumber)
        email!.text = String(member["email"] as NSString)
        bio!.text = String(member["bio"] as NSString)
        selfie!.image = self.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved.value:
            NSLog("Mail saved")
        case MFMailComposeResultSent.value:
            NSLog("Mail sent")
        case MFMailComposeResultFailed.value:
            NSLog("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
*/
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult, error: NSError) {
        
        switch result.value {
        case MessageComposeResultCancelled.value:
            NSLog("Message cancelled")
//        case MessageComposeResultSaved.value:
//            NSLog("Mail saved")
        case MessageComposeResultSent.value:
            NSLog("Message sent")
        case MessageComposeResultFailed.value:
            NSLog("Message sent failure: %@", error.localizedDescription)
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
 /*   func showSMS(file: NSString!) {
    
    }
*/
  }
