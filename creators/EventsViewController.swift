//
//  EventsViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/23/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class EventsTableViewCell: SWTableViewCell {
    var index = Int()
    var status = String()
    var eventId = String()
    
    @IBOutlet var title: UILabel?
    @IBOutlet var details: UILabel?
    @IBOutlet var day: UILabel?
    @IBOutlet var date: UILabel?
    @IBOutlet var month: UILabel?
    @IBOutlet var rsvpButton: RsvpButton?
    
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
        
        /*var eventRsvp = eventsRsvps[eventRsvpId]
        if (eventRsvp != nil) {
            eventRsvp!["status"] = status
            eventRsvp!.saveEventually()
        }*/
        
        var eventRsvp = eventsRsvps[eventId]
        if eventRsvp != nil {
            eventRsvp!["status"] = status
            eventRsvp!.saveEventually()
        }
    }
    
    override  init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }

   required init(coder aDecoder: NSCoder) {
       //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
   }
}

var eventsRsvps = Dictionary<String, PFObject>()

class EventsViewController: UITableViewController, UITableViewDelegate, SWTableViewCellDelegate, EventViewControllerDelegate, UITableViewDataSource {
    // define the class
    var eventsData: NSArray = []
    var eventsPhotos = Dictionary<String, PFImageView>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = ShiftColor.Blue.color()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "EventsCell")
        
        var query = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error != nil) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                self.eventsData = objects

                for element : AnyObject in self.eventsData {
                    if let event = element as? PFObject  {
                        // load photo to eventsPhotos
                        var photo: PFImageView = PFImageView()
                        photo.image = UIImage(named: "square")
                        photo.file = event["photo"] as? PFFile
                        photo.loadInBackground({(UIImage image, NSError error) in
                            if (error != nil) {
                                NSLog("error " + error.localizedDescription)
                            } else {
                                self.tableView.reloadData()
                            }
                        })
                        self.eventsPhotos.updateValue(photo, forKey: event.objectId)
    
                        // load event to eventsRsvps
                        let rsvpEvent = event
                        let rsvpMember = PFUser.currentUser()
                        var query = PFQuery(className: "EventRsvp")
                        query.whereKey("event", equalTo: rsvpEvent)
                        query.whereKey("member", equalTo: rsvpMember)
                        query.getFirstObjectInBackgroundWithBlock({(PFObject eventRsvp, NSError error) in
                            if (error != nil) {
                                NSLog("RSVP - Could not retrieve EventRsvp. " + error.localizedDescription)
                                // if the user has not rsvp'd for this event, set empty object
                                var eventRsvp = PFObject(className: "EventRsvp")
                                eventRsvp["event"] = rsvpEvent
                                eventRsvp["member"] = rsvpMember
                                eventRsvp["status"] = ""
                                eventsRsvps.updateValue(eventRsvp, forKey: event.objectId)
                            } else {
                                eventsRsvps.updateValue(eventRsvp, forKey: event.objectId)
                            }
                            
                            self.tableView.reloadData()
                        })
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as EventsTableViewCell
        
        if self.eventsData.count > 0 {
            let event = self.eventsData.objectAtIndex(indexPath.row) as PFObject
            cell.eventId = event.objectId
            
            NSLog("before setting status")
            NSLog("    count is: \(eventsRsvps.count)")
            
            let eventRsvp = eventsRsvps[event.objectId]
            if eventRsvp != nil {
                if eventRsvp!["status"] != nil {
                    cell.status = eventRsvp!["status"] as NSString
                }
                cell.rsvpButton!.setBackground(cell.status)
            } 
            
            let title = String(event["title"] as NSString)
            let details = String(event["details"] as NSString)
            
            var df = NSDateFormatter()
            df.dateFormat = "yyyy-MM-dd-EEEE"
            var dateString: NSString = df.stringFromDate(event["startDate"] as NSDate)
            
            var month = dateString.substringWithRange(NSRange(location: 5, length: 2))
            var date = dateString.substringWithRange(NSRange(location: 8, length: 2))
            var day = dateString.substringWithRange(NSRange(location: 11, length: 3))
            
            var monthVal = month.toInt()
            month = Months.fromRaw(monthVal!)!.month()
            
            //cell.leftUtilityButtons = self.leftButtons()
            //cell.rightUtilityButtons = self.rightButtons()
            cell.delegate = self
            
            cell.title!.text = title
            cell.details!.numberOfLines = 3
            cell.details!.text = details
            cell.day!.text = day
            cell.date!.text = date
            cell.month!.text = month
        }
        return cell
    }
    
    func didFinish(controller: EventViewController, eventRsvp: PFObject) {
//        colorLabel.text = "The Color is " +  text
//        controller.navigationController?.popViewControllerAnimated(true)
        eventsRsvps[eventRsvp.objectId] = eventRsvp
        self.tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var eventViewController: EventViewController = segue.destinationViewController as EventViewController
        var eventIndex = tableView.indexPathForSelectedRow()!.row
        var selectedEvent = self.eventsData.objectAtIndex(eventIndex) as PFObject
        eventViewController.event = selectedEvent
        eventViewController.image = self.eventsPhotos[selectedEvent.objectId]!.image!
        eventViewController.rsvp = eventsRsvps[selectedEvent.objectId]!
        //eventViewController.rsvpId = selectedEvent.objectId
        eventViewController.delegate = self
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("eventSegue", sender: self)
    }
    
}
