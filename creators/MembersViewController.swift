//
//  MembersViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/10/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

class MembersTableViewCell: UITableViewCell {
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
    }
}

class MembersViewController: UITableViewController, UISearchDisplayDelegate, UISearchBarDelegate {
    // define the class
    var membersData: NSArray = []
    var membersPhotos = Dictionary<String, PFImageView>()
    var searchResults: NSArray = []
    
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
            
                for element: AnyObject in self.membersData {
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
                        self.membersPhotos.updateValue(selfie, forKey: member.objectId)
                        //println(element)
                    }
                }
                self.tableView.reloadData()
            }
        })
        self.searchDisplayController.delegate = self
        self.searchDisplayController.searchResultsDataSource = self
        self.searchDisplayController.searchResultsDelegate = self
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
        if tableView == self.searchDisplayController.searchResultsTableView {
            return self.searchResults.count
        } else {
            return self.membersData.count
        }
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        let cell = self.tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as MembersTableViewCell
        
        var member : PFUser?
        
        if (tableView == self.searchDisplayController.searchResultsTableView && self.searchResults.count > 0) {
            member = self.searchResults.objectAtIndex(indexPath.row) as? PFUser
            var name = member!["firstName"] as NSString
        } else {
            if self.membersData.count > 0 {
                member = self.membersData.objectAtIndex(indexPath.row) as? PFUser
            }
        }
        
        if member {
            let firstName = String(member!["firstName"] as NSString)
            let lastName = String(member!["lastName"] as NSString)
            let selfie = self.membersPhotos[member!.objectId]!.image
            
            cell.textLabel.text = firstName + " " + lastName
            cell.imageView.image = selfie
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var memberViewController: MemberViewController = segue.destinationViewController as MemberViewController
        var memberIndex = NSInteger()
        var selectedMember = PFUser()
        
        if (self.searchDisplayController.active == true) {
            memberIndex = self.searchDisplayController.searchResultsTableView!.indexPathForSelectedRow().row
            selectedMember = self.searchResults.objectAtIndex(memberIndex) as PFUser
        } else {
            memberIndex = self.tableView!.indexPathForSelectedRow().row
            selectedMember = self.membersData.objectAtIndex(memberIndex) as PFUser
        }

        memberViewController.member = selectedMember
        memberViewController.image = self.membersPhotos[selectedMember.objectId]!.image
    }
    
    func filterContentForSearchText(searchText: NSString!) {
        //  Use NSPredicate after move to Core Data
        //let resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
        //searchResults = membersData.filteredArrayUsingPredicate(resultPredicate)
        
        // var query: PFQuery = PFUser.query()
        //query.whereKey("firstName", matchesRegex: NSString(format: "(?i:^.*%@.*$)", searchText))
        //query.whereKey("lastName", matchesRegex: NSString(format: "(?i:^.*%@.*$)", searchText))
        
        var queryFirst: PFQuery = PFUser.query()
        var queryLast: PFQuery = PFUser.query()
        queryFirst.whereKey("firstName", matchesRegex: NSString(format: "(?i:^.*%@.*$)", searchText))
        queryLast.whereKey("lastName", matchesRegex: NSString(format: "(?i:^.*%@.*$)", searchText))
        var queries: NSArray = [queryFirst, queryLast]
        var query: PFQuery = PFQuery.orQueryWithSubqueries(queries)
        
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error) {
                NSLog("error " + error.localizedDescription)
            } else {
                self.searchResults = objects
                self.searchDisplayController.searchResultsTableView.reloadData()
            }
        })
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: NSString!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        //self.performSegueWithIdentifier("memberSegue", sender: self)
        self.searchDisplayController.setActive(false, animated: true)
    }

}
