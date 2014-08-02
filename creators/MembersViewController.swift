//
//  MembersViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/10/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class MembersViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    // define the class
    var membersData: NSArray = []
    var membersPhotos = Dictionary<String, PFImageView>()
    
    var lastDescriptor: NSSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true, selector: "caseInsensitiveCompare:")
    var firstDescriptor: NSSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true, selector: "caseInsensitiveCompare:")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                self.membersData = objects
                self.membersData = self.membersData.sortedArrayUsingDescriptors([self.lastDescriptor, self.firstDescriptor])
            
                for element : AnyObject in self.membersData {
                    if let member = element as? PFUser  {
                        var selfie: PFImageView = PFImageView()
                        selfie.image = UIImage(named: "square")
                        selfie.file = member["selfie"] as? PFFile
                        selfie.loadInBackground({(UIImage image, NSError error) in
                            if (error) {
                                NSLog("error " + error.localizedDescription)
                            } else {
                                self.tableView.reloadData()
                            }
                        })
                        self.membersPhotos.updateValue(selfie, forKey: toString(member["username"]))
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
        return self.membersData.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as UITableViewCell
            
        if self.membersData.count > 0 {
            let member = self.membersData.objectAtIndex(indexPath.row) as PFUser
            let firstName = String(member["firstName"] as NSString)
            let lastName = String(member["lastName"] as NSString)
            let selfie = self.membersPhotos[toString(member["username"])]!.image
            
            cell.textLabel.text = firstName + " " + lastName
            cell.imageView.image = selfie
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var memberViewController: MemberViewController = segue.destinationViewController as MemberViewController
        var memberIndex = tableView!.indexPathForSelectedRow().row
        var selectedMember = self.membersData.objectAtIndex(memberIndex) as PFUser
        memberViewController.member = selectedMember
        memberViewController.selfie = self.membersPhotos[toString(selectedMember["username"])]
        memberViewController.selfie.image = self.membersPhotos[toString(selectedMember["username"])]!.image
    }
    
}
