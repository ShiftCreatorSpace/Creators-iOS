//
//  EventsViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/23/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class EventsTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel
    @IBOutlet var location : UILabel
    @IBOutlet var date : UILabel
    @IBOutlet var time : UILabel
    @IBOutlet var details: UILabel
//    @IBOutlet var rsvp : UIButton
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        
        
    }
}

class EventsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    // define the class
    var eventsData: NSArray = []
//    var eventsPhotos = Dictionary<String, PFImageView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "EventsCell")
        
        
        var query = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                
                println("before get objects")
                self.eventsData = objects

                println("after get objects")                
/*
                for element : AnyObject in self.eventsData {
                    if let event = element as? PFObject  {
                        var photo: PFImageView = PFImageView()
                        photo.image = UIImage(named: "square")
                        photo.file = event["photo"] as? PFFile
                        photo.loadInBackground({(UIImage image, NSError error) in
                            if (error) {
                                NSLog("error " + error.localizedDescription)
                            } else {
                                self.tableView.reloadData()
                            }
                        })
                        self.eventsPhotos.updateValue(photo, forKey: toString(event["objectId"]))
                        //println(element)
                    }
                }
*/
                
                
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
        return self.eventsData.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        //let cell = EventsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as EventsTableViewCell
        
        
         println("entering load cell")
        
        if self.eventsData.count > 0 {
            let event = self.eventsData.objectAtIndex(indexPath.row) as PFObject
            let title = String(event["title"] as NSString)
            let location = String(event["locationName"] as NSString)
            let date = toString(event["startDate"])
            let time = toString(event["endDate"])
            let details = String(event["details"] as NSString)
            
        println("after parsing dictionary for event details")
            
/*
            println(event)
            println(title)
            println(location)
            println(date)
            println(time)
            println(details)
*/
            //cell.textLabel.text = title
            //cell.detailTextLabel.numberOfLines = 6
            //cell.detailTextLabel.text = deskription

            cell.title.text = title
            cell.location.text = location
            cell.date.text = date
            cell.time.text = time
            cell.details.numberOfLines = 3
            cell.details.text = details
      //      cell.rsvp

/*
            cell.title.text = "Hi"
            cell.location.text = "hi"
            cell.date.text = "hi"
            cell.time.text = "hi"
            cell.details.text = "hi"
*/
        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var eventViewController: EventViewController = segue.destinationViewController as EventViewController
        var eventIndex = tableView!.indexPathForSelectedRow().row
        var selectedEvent = self.eventsData.objectAtIndex(eventIndex) as PFObject
        eventViewController.event = selectedEvent
     //   eventViewController.photo = self.eventsPhotos[toString(selectedEvent["objectId"])]
     //   eventViewController.photo!.image = self.eventsPhotos[toString(selectedEvent["objectId"])]!.image
    }

}
