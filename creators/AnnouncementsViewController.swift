//
//  AnnouncementsViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/20/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class AnnouncementsTableViewCell: SWTableViewCell {
    var status = String()
    var requestId = String()
    
    @IBOutlet var title: UILabel?
    @IBOutlet var details: UILabel?
    @IBOutlet var requester: ShiftImageView?
    @IBOutlet var requestButton: RequestButton?

    @IBAction func requestAction(sender: AnyObject) {
        if status == "true" {
            status = "false"
        } else {
            status = "true"
        }
        
        requestButton!.setBackground(status)
        
        var requestResponse = requestResponses[requestId]
        if requestResponse != nil {
            requestResponse!["status"] = status
            requestResponse!.saveEventually()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}

class RequestsTableViewCell: AnnouncementsTableViewCell {
    //@IBOutlet var requester: UIImageView?
    //@IBOutlet var rsvp: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}

var requestResponses = Dictionary<String, PFObject>()

class AnnouncementsViewController: UITableViewController, UITableViewDelegate, SWTableViewCellDelegate, AnnouncementViewControllerDelegate, UITableViewDataSource {
    // define the class
    var membersData: NSArray = []
    var combinedData: NSMutableArray = []
    var requestsData: NSArray = []
    var announcementsData: NSArray = []
    var announcementsPhotos = Dictionary<String, PFImageView>()
    var requestsPhotos = Dictionary<String, PFImageView>()
    
    enum SegmentedControls: Int {
        case Combined
        case Announcements
        case Requests
    }
    var segment = SegmentedControls.Combined.toRaw()
    
    var pinnedDescriptor: NSSortDescriptor = NSSortDescriptor(key: "pinned", ascending: false)
    var createDateDescriptor: NSSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
    
    
    @IBAction func settings(sender: SettingsBarButtonItem) {
        //sender.displaySettings(self)
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        self.segment = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
//    @IBOutlet var announcementsSegmentedControl: HMSegmentedControl!
    @IBOutlet var announcementsSegmentedControl: UISegmentedControl!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up navbar title and font
        self.navigationController!.navigationBar.barTintColor = ShiftColor.Red.color()
        self.navigationItem.title = "Shift News"
        
        let font = UIFont(name: "GothamRounded-Book", size: 22)
        let titleDict: NSDictionary = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict

        
        //Set up segmented control color and font
        announcementsSegmentedControl.tintColor = ShiftColor.Red.color()
        let segmentFont = UIFont(name: "GothamRounded-Book", size: 18)
        announcementsSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        announcementsSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: segmentFont, NSUnderlineStyleAttributeName: 1], forState: UIControlState.Selected)
        
        
//        
//        self.announcementsSegmentedControl!.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleWidth
//
//        self.announcementsSegmentedControl!.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
//        self.announcementsSegmentedControl!.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown

        
/*        HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight"]];
        segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        segmentedControl1.frame = CGRectMake(0, 40 + yDelta, 320, 40);
        segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmentedControl1];
*/
        
        
        /// Find font names
        /*for family in UIFont.familyNames() {
        NSLog(family as String)
        for name in UIFont.fontNamesForFamilyName(family as String) {
        NSLog(name as String)
        }
        }*/
        
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
        query.includeKey("requester")
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error != nil) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                self.requestsData = objects
                
                // Iterate through each Request
                for element : AnyObject in self.requestsData {
                    if let request = element as? PFObject  {
                        self.combinedData.addObject(request)
                        
                        var photo: PFImageView = PFImageView()
                        photo.image = UIImage(named: "square")
                        let requester: AnyObject! = request["requester"]
                        photo.file = requester["selfie"] as? PFFile
                        photo.loadInBackground({(UIImage image, NSError error) in
                            if (error != nil) {
                                NSLog("error " + error.localizedDescription)
                            } else {
                                self.tableView.reloadData()
                            }
                        })
                        self.requestsPhotos.updateValue(photo, forKey: requester.objectId)
                        
                        // load request to requestResponses
                        /// can be optimized -- do not need to run query for each request, just query.whereKey("member", equalTo: PFUser.currentUser()) once for all RequestResponses for a user. don't forget to create empty RequestResponses when populating dictionary
                        let requestMember = PFUser.currentUser()
                        var query = PFQuery(className: "RequestResponse")
                        query.whereKey("request", equalTo: request)
                        query.whereKey("member", equalTo: requestMember)
                        query.getFirstObjectInBackgroundWithBlock({(PFObject requestResponse, NSError error) in
                            if (error != nil) {
                                NSLog("REQUEST - Could not retrieve RequestResponse. Creating new one.")
                                // if the user has not responded to this request, set empty object
                                //var requestResponse = PFObject(className: "RequestResponse")
                                
                                var requestResponse = PFObject(className: "RequestResponse", dictionary: ["request": request,"member": requestMember,"status": "false"])
                            
                                //requestResponse["request"] = request
                                //requestResponse["member"] = requestMember
                                //requestResponse["status"] = "false"
                                
                                requestResponses.updateValue(requestResponse, forKey: request.objectId)
                            } else {
                                requestResponses.updateValue(requestResponse, forKey: request.objectId)
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
        
        var cellIdentifier = "announcementCell"
        if self.segment == SegmentedControls.Requests.toRaw() {
            cellIdentifier = "requestCell"
        } else if self.segment == SegmentedControls.Combined.toRaw()
                && self.combinedData.count > indexPath.row
                && self.combinedData[indexPath.row].parseClassName == "Request" {
            cellIdentifier = "requestCell"
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as AnnouncementsTableViewCell

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

            if announcement.parseClassName == "Announcement" {
                
            } else if announcement.parseClassName == "Request" && requestResponses.count > 0 {
                cell.requestId = announcement.objectId
                
                let requestResponse = requestResponses[announcement.objectId]
                if requestResponse != nil {
                    if requestResponse!["status"] != nil {
                        cell.status = requestResponse!["status"] as NSString
                    }
                    cell.requestButton!.setBackground(cell.status)
                }
                let requester: AnyObject! = announcement["requester"]

                if self.requestsPhotos[requester.objectId] != nil {
                    let selfie = self.requestsPhotos[requester.objectId]!.image
                    cell.requester!.image = selfie
                }
            }
            
            cell.delegate = self
            cell.title!.text = title
            cell.details!.numberOfLines = 3
            cell.details!.text = details
        }
        return cell
    }
    
    func didFinish(controller: AnnouncementViewController, requestResponse: PFObject, requestId: String) {
        requestResponses[requestId] = requestResponse
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var announcementViewController: AnnouncementViewController = segue.destinationViewController as AnnouncementViewController
        var announcementIndex = tableView.indexPathForSelectedRow()!.row
        
        var selectedAnnouncement: PFObject
        
        switch self.segment {
            case SegmentedControls.Announcements.toRaw():
                selectedAnnouncement = self.announcementsData.objectAtIndex(announcementIndex) as PFObject
            case SegmentedControls.Requests.toRaw():
                selectedAnnouncement = self.requestsData.objectAtIndex(announcementIndex) as PFObject
            default:
                selectedAnnouncement = self.combinedData.objectAtIndex(announcementIndex) as PFObject
        }
        
        announcementViewController.announcement = selectedAnnouncement
        if selectedAnnouncement.parseClassName == "Announcement" {
            announcementViewController.image = self.announcementsPhotos[selectedAnnouncement.objectId]!.image!
        } else {
            /// temporarily setting image to square, need to adjust AnnouncementViewController to handle Request cells
            let requester: AnyObject! = selectedAnnouncement["requester"]
            if self.requestsPhotos[requester.objectId] != nil {
                let selfie = self.requestsPhotos[requester.objectId]!.image
                announcementViewController.image = selfie!
            } else {
                announcementViewController.image = UIImage(named: "square")
            }
            announcementViewController.response = requestResponses[selectedAnnouncement.objectId]!
            print("setting response: ")
            print(announcementViewController.response)
        }
        
        announcementViewController.delegate = self
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
