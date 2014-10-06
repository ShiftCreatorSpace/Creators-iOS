//
//  AnnouncementViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/26/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

protocol AnnouncementViewControllerDelegate{
    func didFinish(controller: AnnouncementViewController, requestResponse: PFObject, requestId: String)
}

class AnnouncementViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    var delegate: AnnouncementViewControllerDelegate? = nil
    var announcement: PFObject = PFObject(className: "Announcement")
    var response = PFObject(className: "RequestResponse")
    var image = UIImage()
    var status = String()
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var details: UITextView?
    @IBOutlet var photo: ShiftImageView?
    
    @IBOutlet var requestButton: RequestButton?
    
    @IBAction func requestAction(sender: AnyObject) {
        if status == "true" {
            status = "false"
        } else {
            status = "true"
        }
        
        requestButton!.setBackground(status)
        
        response["status"] = status
        response.saveEventually()
        
        if delegate != nil {
            delegate!.didFinish(self, requestResponse: response, requestId: announcement.objectId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = ShiftColor.Red.color()
        
        if announcement.parseClassName == "Announcement" {
            self.requestButton!.hidden = true
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel!.text = String(announcement["title"] as NSString)
        details!.text = String(announcement["details"] as NSString)
        
        //println(details.frame)
        //var frame: CGRect = details!.frame
        //frame.size.height = details!.contentSize.height;
        //details!.frame = frame
        
        //photo!.frame = CGRectMake(photo!.frame.origin.x, photo!.frame.origin.y, self.image.size.width, self.image.size.height)
        //photo!.contentMode = UIViewContentMode.ScaleAspectFit
        //        photo.frame.size.height = image.size.height
        photo!.image = self.image
        //photo!.layer.cornerRadius = photo!.frame.size.width / 2
        //photo!.clipsToBounds = true
        
        if response["status"] != nil {
            status = String(response["status"] as NSString)
        }
        self.requestButton!.setBackground(status)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
