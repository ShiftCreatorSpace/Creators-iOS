//
//  EventViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/29/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

protocol EventViewControllerDelegate{
    func didFinish(controller: EventViewController, eventRsvp: PFObject)
}

class EventViewController: UIViewController {
    var delegate: EventViewControllerDelegate? = nil
    var event: PFObject = PFObject(className: "Event")
    var rsvp = PFObject(className: "EventRsvp")
    //var rsvpId = String()
    var image = UIImage()
    var status = String()
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var location : UILabel?
    @IBOutlet var date : UILabel?
    @IBOutlet var time : UILabel?
    @IBOutlet var details: UITextView?
    @IBOutlet var photo: UIImageView?
//    @IBOutlet var status : UILabel?
    @IBOutlet var rsvpButton : RsvpButton?
    
    @IBAction func rsvpAction(sender: AnyObject) {
        switch status {
            case "GOING":
                status = "MAYBE"
            case "MAYBE":
                status = "NOT"
            case "NOT":
                status = "GOING"
            default:
                status = "GOING"
        }
        
        rsvpButton!.setBackground(status)
        
        //var rsvp = eventsRsvps[rsvpId]
        
        rsvp["status"] = status
        rsvp.saveEventually()
        
        if delegate != nil {
            delegate!.didFinish(self, eventRsvp: rsvp)
        }
        
        // Set status for rsvp in full list of user's rsvp's as well
//        var eventRsvp = eventsRsvps[rsvp.objectId]
  //      if eventRsvp != nil {
    //        eventRsvp!["status"] = status
      //  }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = ShiftColor.Blue.color()
        
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel!.text = String(event["title"] as NSString)
        location!.text = String(event["locationName"] as NSString)
        details!.text = String(event["details"] as NSString)
        photo!.image = self.image
        
        //var rsvp = eventsRsvps[rsvpId]
        if rsvp["status"] != nil {
            status = String(rsvp["status"] as NSString)
        }
        
        var df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd-EEEE"
        var dateString: NSString = df.stringFromDate(event["startDate"] as NSDate)
        df.dateFormat = "HH:mm"
        var startTime: NSString = df.stringFromDate(event["startDate"] as NSDate)
        var endTime: NSString = df.stringFromDate(event["endDate"] as NSDate)
        
        //var month = dateString.substringWithRange(NSRange(location: 5, length: 2))
        //var date = dateString.substringWithRange(NSRange(location: 8, length: 2))
        //var day = dateString.substringWithRange(NSRange(location: 11, length: 3))
        
        date!.text = dateString
        time!.text = startTime + " - " + endTime
        
        self.rsvpButton!.setBackground(status)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
