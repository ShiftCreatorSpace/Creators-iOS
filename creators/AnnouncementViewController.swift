//
//  AnnouncementViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/26/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    var announcement: PFObject = PFObject(className: "Announcement")
    var image = UIImage()
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var details: UITextView?
    @IBOutlet var photo: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = ShiftColor.Red.color()
//        self.tabBarController!.tabBar.tintColor = UIColor.yellowColor()
        
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel!.text = String(announcement["title"] as NSString)
        details!.text = String(announcement["details"] as NSString)
        
        //println(details.frame)
        var frame: CGRect = details!.frame
        frame.size.height = details!.contentSize.height;
        details!.frame = frame
        //println(details.frame)
        
        
        //println(self.image.size.width)
        //println(self.image.size.height)
        
        photo!.frame = CGRectMake(photo!.frame.origin.x, photo!.frame.origin.y, self.image.size.width, self.image.size.height)
        photo!.contentMode = UIViewContentMode.ScaleAspectFit
        //        photo.frame.size.height = image.size.height
        photo!.image = self.image
        
        
        //println(photo.frame)
        //println(photo.image.size.width)
        //println(photo.image.size.height)
        //if (photo) {
            //photo!.image = announcement["photo"] as UIImage
            
            //photo.image = photo.image
            //println(photo)
        //}
//        UIImage * img = [UIImage imageNamed:@"someImage.png"];
//        CGSize imgSize = img.size;
        
        //calculate scale ratio on width
        
//        float ratio=yourImageView.frame.size.width/imgSize.width;
        //check scaled height (using same ratio to keep aspect)
        
//        float scaledHeight=imgSize.height*ratio;
//        if(scaledHeight < yourImageView.frame.size.height)
//        {
            //update height of your imageView frame with scaledHeight
//        }
        //titleLabel.text = self.album?.title
        //albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album?.largeImageURL)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
