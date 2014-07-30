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
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var location : UILabel
    @IBOutlet var date : UILabel
    @IBOutlet var time : UILabel
    @IBOutlet var details: UITextView
    //@IBOutlet var photo: UIImageView
    //    @IBOutlet var rsvp : UIButton
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        
        titleLabel.text = String(event["title"] as NSString)
        location.text = String(event["locationName"] as NSString)
        date.text = String(event["date"] as NSString)
        time.text = String(event["time"] as NSString)
        details.text = String(event["details"] as NSString)
        //if (photo) {
        //photo!.image = event["photo"] as UIImage
        
        //photo.image = photo.image
        //println(photo)
        //}
        
        //titleLabel.text = self.album?.title
        //albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album?.largeImageURL)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
