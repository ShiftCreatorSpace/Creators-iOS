//
//  AnnouncementsViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/20/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class AnnouncementsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    // define the class
    var announcementsData: NSArray = []
    var announcementsPhotos = Dictionary<String, PFImageView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className: "Announcement")
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                self.announcementsData = objects
                
                
                
                /*for element : AnyObject in self.announcementsData {
                    if let announcement = element as? PFObject  {
                        println(element)
                    }
                }*/
                
                for element : AnyObject in self.announcementsData {
                    if let announcement = element as? PFObject  {
                        var photo: PFImageView = PFImageView()
                        photo.image = UIImage(named: "square")
                        photo.file = announcement["photo"] as? PFFile
                        photo.loadInBackground({(UIImage image, NSError error) in
                            if (error) {
                                NSLog("error " + error.localizedDescription)
                            } else {
                                self.tableView.reloadData()
                            }
                        })
                        self.announcementsPhotos.updateValue(photo, forKey: toString(announcement["objectId"]))
                        //println(element)
                    }
                }


                
                
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    /*override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
    return 1
    }*/
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.announcementsData.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        
        //let cell = tableView!.dequeueReusableCellWithIdentifier("announce", forIndexPath: indexPath) as UITableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("announcementCell", forIndexPath: indexPath) as UITableViewCell
        
        
        if self.announcementsData.count > 0 {
            let announcement = self.announcementsData.objectAtIndex(indexPath.row) as PFObject
            let title = String(announcement["title"] as NSString)
            let details = String(announcement["details"] as NSString)
            //let photo = String(announcement["objectId"] as NSString)
            
            println(title)
            //println(photo)
            
            cell.textLabel.text = title
            cell.detailTextLabel.numberOfLines = 3
            cell.detailTextLabel.text = details
            //cell.image = self.announcementsPhotos[toString(announcement["objectId"])]!.image
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var announcementViewController: AnnouncementViewController = segue.destinationViewController as AnnouncementViewController
        var announcementIndex = tableView!.indexPathForSelectedRow().row
        var selectedAnnouncement = self.announcementsData.objectAtIndex(announcementIndex) as PFObject
        announcementViewController.announcement = selectedAnnouncement
        announcementViewController.photo = self.announcementsPhotos[toString(selectedAnnouncement["objectId"])]
        announcementViewController.photo!.image = self.announcementsPhotos[toString(selectedAnnouncement["objectId"])]!.image
    }

/*
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath: NSIndexPath!) {
        //var messageAlert: UIAlertView = UIAlertView(title: "Row Selected", message: "You've selected at row", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil, String[]())
        
        
        
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
        // Display Alert Message
        //messageAlert show];
        
    }
*/
}
