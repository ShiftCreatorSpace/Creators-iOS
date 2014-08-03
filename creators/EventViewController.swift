//
//  EventViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/29/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var event: PFObject = PFObject(className: "Event")
    var rsvp = PFObject(className: "EventRsvp")
    var image = UIImage()
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var location : UILabel
    @IBOutlet var date : UILabel
    @IBOutlet var time : UILabel
    @IBOutlet var details: UITextView
    @IBOutlet var photo: UIImageView
    @IBOutlet var status : UILabel
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel.text = String(event["title"] as NSString)
        location.text = String(event["locationName"] as NSString)
        date.text = toString(event["startDate"])
        time.text = toString(event["endDate"])
        details.text = String(event["details"] as NSString)
        photo.image = self.image
        
        self.status.text = String(rsvp["status"] as NSString)
        
        switch self.status.text {
            case toString("GOING"):
                self.status.text = "Going"
                self.status.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.392, alpha: 1.0)
            case toString("MAYBE_GOING"):
                self.status.text = "Maybe"
                self.status.backgroundColor = UIColor(red: 0.203, green: 0.667, blue: 0.863, alpha: 1.0)
            case toString("NOT_GOING"):
                self.status.text = "Not Going"
                self.status.backgroundColor = UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1.0)
            default:
                println("Invalid status/no status set for EventRsvp")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
