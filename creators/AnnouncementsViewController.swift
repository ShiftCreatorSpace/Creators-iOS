//
//  AnnouncementsViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/20/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class AnnouncementsTableViewCell: SWTableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var details: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}

class AnnouncementsViewController: UITableViewController, UITableViewDelegate, SWTableViewCellDelegate, UITableViewDataSource {
    // define the class
    var combinedData: NSMutableArray = []
    var requestsData: NSArray = []
    var announcementsData: NSArray = []
    var announcementsPhotos = Dictionary<String, PFImageView>()
    var requestResponses = Dictionary<String, PFObject>()

    
    enum SegmentedControls: NSInteger {
        case Combined = 0
        case Announcements = 1
        case Requests = 2
    }
    var segment = SegmentedControls.Combined.toRaw()
    
    var pinnedDescriptor: NSSortDescriptor = NSSortDescriptor(key: "pinned", ascending: false)
    var createDateDescriptor: NSSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var loginController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("login") as UIViewController
        self.navigationController!.pushViewController(loginController, animated: false)
    }
    
    @IBOutlet var announcementSegmentedControl : UISegmentedControl?
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        /*println("# of Segments = \(sender.numberOfSegments)")
        
        switch sender.selectedSegmentIndex {
        case 0:
            println("segment clicked: 1")
        case 1:
            println("segment clicked: 2")
        case 2:
            println("segment clicked: 3")
        default:
            break;
        }*/
        
        self.segment = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    func leftButtonsJoin() -> NSArray {
        var leftUtilityButtons: NSMutableArray = NSMutableArray()
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor(red: 0.298, green: 0.851, blue: 0.392, alpha: 1.0), title: "Join")
        return leftUtilityButtons
    }
    
    func leftButtonsLeave() -> NSArray {
        var leftUtilityButtons: NSMutableArray = NSMutableArray()
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1.0), title: "Leave")
        return leftUtilityButtons
    }
/*
    func rightButtons() -> NSArray {
        var rightUtilityButtons: NSMutableArray = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0), title: "R_One")
        
        return rightUtilityButtons
    }
*/
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex withIndex: NSInteger) {
        let indexPath = self.tableView.indexPathForCell(cell)
        
        switch self.segment {
        case SegmentedControls.Announcements.toRaw():
            let request = self.combinedData.objectAtIndex(indexPath!.row) as PFObject
        case SegmentedControls.Requests.toRaw():
            let request = self.combinedData.objectAtIndex(indexPath!.row) as PFObject
        default:
            let request = self.combinedData.objectAtIndex(indexPath!.row) as PFObject
        }
        let request = self.combinedData.objectAtIndex(indexPath!.row) as PFObject
        //let requestMember = PFUser.currentUser()
        var requestResponse = self.requestResponses[request.objectId]!
        var requestStatus: AnyObject! = requestResponse["status"]
        
        if requestStatus as NSObject == true {
            println("Setting response to 'No'")
            requestStatus = false
        } else {
            println("Setting response to 'Yes'")
            requestStatus = true
        }
        
        /*switch requestStatus {
        case 0 as NSObject:
            println("Setting response to 'Yes'")
            requestStatus = true
        case 1 as NSObject:
            println("Setting response to 'No'")
            requestStatus = false
        default:
            println("Left Wut.")
        }*/
        
        requestResponse["status"] = requestStatus
        requestResponse.saveEventually()

        self.tableView.reloadData()
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex withIndex: NSInteger) {
        switch withIndex {
        case 0:
            println("Right One")
        default:
            println("Right Wut.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Query for Announcements
        // Set announcementsData and add to combinedData
        // Set announcementsPhotos
        var query = PFQuery(className: "Announcement")
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error != nil) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                self.announcementsData = objects
                self.announcementsData = self.announcementsData.sortedArrayUsingDescriptors([self.pinnedDescriptor, self.createDateDescriptor])
                
                for element : AnyObject in self.announcementsData {
                    if let announcement = element as? PFObject  {
                        self.combinedData.addObject(announcement)
                        
                        var photo: PFImageView = PFImageView()
                        photo.image = UIImage(named: "square")
                        photo.file = announcement["photo"] as? PFFile
                        photo.loadInBackground({(UIImage image, NSError error) in
                            if (error != nil) {
                                NSLog("error " + error.localizedDescription)
                            } else {
                                self.tableView.reloadData()
                            }
                        })
                        self.announcementsPhotos.updateValue(photo, forKey: announcement.objectId)
                    }
                }
                self.combinedData.sortUsingDescriptors([self.pinnedDescriptor, self.createDateDescriptor])
                self.tableView.reloadData()
            }
        })
        
        // Query for Requests
        // Set requestsData and add to combinedData
        query = PFQuery(className: "Request")
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error != nil) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                self.requestsData = objects
                
                for element : AnyObject in self.requestsData {
                    if let request = element as? PFObject  {
                        self.combinedData.addObject(request)
                        
                        // load request to requestResponses
                        let requestMember = PFUser.currentUser()
                        var query = PFQuery(className: "RequestResponse")
                        query.whereKey("request", equalTo: request)
                        query.whereKey("member", equalTo: requestMember)
                        query.getFirstObjectInBackgroundWithBlock({(PFObject requestResponse, NSError error) in
                            if (error != nil) {
                                NSLog("REQUEST - Could not retrieve RequestResponse. " + error.localizedDescription)
                                // if the user has not responded to this request, set empty object
                                var requestResponse = PFObject(className: "RequestResponse")
                                requestResponse["request"] = request
                                requestResponse["member"] = requestMember
                                requestResponse["status"] = false
                                self.requestResponses.updateValue(requestResponse, forKey: request.objectId)
                            } else {
                                self.requestResponses.updateValue(requestResponse, forKey: request.objectId)
                            }
                            self.tableView.reloadData()
                        })

                    }
                }
                self.combinedData.sortUsingDescriptors([self.pinnedDescriptor, self.createDateDescriptor])
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.combinedData.count
        switch self.segment {
        case SegmentedControls.Announcements.toRaw():
            return self.announcementsData.count
        case SegmentedControls.Requests.toRaw():
            return self.requestsData.count
        default:
            return self.combinedData.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCellWithIdentifier("announcementCell", forIndexPath: indexPath) as AnnouncementsTableViewCell

        if self.combinedData.count > 0 {
            
            var announcement: PFObject
            
            switch self.segment {
            case SegmentedControls.Announcements.toRaw():
                announcement = self.announcementsData.objectAtIndex(indexPath.row) as PFObject
            case SegmentedControls.Requests.toRaw():
                announcement = self.requestsData.objectAtIndex(indexPath.row) as PFObject
            default:
                announcement = self.combinedData.objectAtIndex(indexPath.row) as PFObject
            }
            
            let title = String(announcement["title"] as NSString)
            let details = String(announcement["details"] as NSString)

            if announcement.parseClassName == "Request" && self.requestResponses.count > 0 {
                println(announcement.objectId)
                let requestResponse = self.requestResponses[announcement.objectId]!
                let requestStatus: AnyObject! = requestResponse["status"]
                if requestStatus as NSObject == true {
                    cell.leftUtilityButtons = self.leftButtonsLeave()
                } else {
                    cell.leftUtilityButtons = self.leftButtonsJoin()
                }
                //cell.rightUtilityButtons = self.rightButtons()
            } else {
                cell.leftUtilityButtons = NSArray()
                //cell.rightUtilityButtons = NSArrary()
            }
            cell.delegate = self

            cell.title!.text = title
            cell.details!.numberOfLines = 3
            cell.details!.text = details

            /// clean up in cell styling
            switch announcement["type"] as NSInteger {
            case 0:
                cell.imageView!.image = UIImage(named: "cell_announce_red")
            case 1:
                cell.imageView!.image = UIImage(named: "cell_announce_orange")
            case 2:
                cell.imageView!.image = UIImage(named: "cell_announce_green")
            case 3:
                cell.imageView!.image = UIImage(named: "cell_announce_blue")
            default:
                cell.imageView!.image = UIImage(named: "square")
            }
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var announcementViewController: AnnouncementViewController = segue.destinationViewController as AnnouncementViewController
        var announcementIndex = tableView.indexPathForSelectedRow()!.row
        var selectedAnnouncement = self.combinedData.objectAtIndex(announcementIndex) as PFObject
        announcementViewController.announcement = selectedAnnouncement
        if selectedAnnouncement.parseClassName == "Announcement" {
            announcementViewController.image = self.announcementsPhotos[selectedAnnouncement.objectId]!.image!
        } else {
            /// temporarily setting image to square, need to adjust AnnouncementViewController to handle Request cells
            announcementViewController.image = UIImage(named: "square")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("announcementSegue", sender: self)
    }
/*
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath: NSIndexPath!) {
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
*/
}
