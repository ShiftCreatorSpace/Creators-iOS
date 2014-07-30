//
//  AnnouncementViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/26/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {

    var announcement: PFObject = PFObject(className: "Announcement")
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var details: UITextView
    @IBOutlet var photo: UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        titleLabel.text = String(announcement["title"] as NSString)
        details.text = String(announcement["details"] as NSString)
        //if (photo) {
            //photo!.image = announcement["photo"] as UIImage
            
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
