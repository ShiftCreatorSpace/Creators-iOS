//
//  MembersViewController.swift
//  creators
//
//  Created by Natasja Nielsen on 7/10/14.
//  Copyright (c) 2014 Creators Co-op. All rights reserved.
//

import Foundation

/*class MembersSearchBar: UISearchBar {
    init(coder aDecoder: NSCoder!)  {
        super.init(frame: CGRect(x: 10, y: 5, width: 300, height: 45))
        self.showsScopeBar = true
    }
    
    /*func setShowsScopeBar() {
        self.invalidateIntrinsicContentSize()
    }*/
    /*
    - (void)setShowsScopeBar:(BOOL)showsScopeBar {
    if ([self showsScopeBar] != showsScopeBar) {
    [self invalidateIntrinsicContentSize];
    }
    [super setShowsScopeBar:showsScopeBar];
    }*/
}*/

class MySearchBar : UISearchBar {
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
        
    }
    
//    func setShowsScopeBar(show: Boolean) {
//        super.setShowsScopeBar(true)
//        super.showsScopeBar = true
//    }

}

class MyView: UIView {
    let tableView: UITableView!
    
    init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView()
    }
    
    func configure() {
        tableView.frame = self.bounds
        self.addSubview(tableView)
    }
}




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
    var atHouseResults: NSArray = []
//    var scopes: NSArray = ["All", "At Home"]
    
    var lastDescriptor: NSSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true, selector: "caseInsensitiveCompare:")
    var firstDescriptor: NSSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true, selector: "caseInsensitiveCompare:")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // Don't show the scope bar or cancel button until editing begins
        [candySearchBar setShowsScopeBar:NO];
        [candySearchBar sizeToFit];
        
        // Hide the search bar until user scrolls up
        CGRect newBounds = self.tableView.bounds;
        newBounds.origin.y = newBounds.origin.y + candySearchBar.bounds.size.height;
        self.tableView.bounds = newBounds;
        */
        
        //self.searchDisplayController.searchBar
        //self.searchDisplayController.searchBar.showsScopeBar = true
        
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
/*        self.searchDisplayController.delegate = self
        self.searchDisplayController.searchResultsDataSource = self
        self.searchDisplayController.searchResultsDelegate = self
*/
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
    
    func filterContentForSearchText(searchText: NSString!, scope: NSString! = "All") {
    //func filterContentForSearchText(searchText: NSString!) {
        //  Use NSPredicate after move to Core Data
        //let resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
        //searchResults = membersData.filteredArrayUsingPredicate(resultPredicate)
        
        //self.searchResults.removeAllObjects()
        
        
        println("Search is happening")

        
        var queryFirst: PFQuery = PFUser.query()
        var queryLast: PFQuery = PFUser.query()
        queryFirst.whereKey("firstName", matchesRegex: NSString(format: "(?i:^.*%@.*$)", searchText))
        queryLast.whereKey("lastName", matchesRegex: NSString(format: "(?i:^.*%@.*$)", searchText))
        var queries: NSMutableArray = [queryFirst, queryLast]
        
        var query: PFQuery = PFQuery.orQueryWithSubqueries(queries)
        
        if scope.isEqualToString("At House") {
            
            println("Scope is: At House")
            
            //var queryScope: PFQuery = PFUser.query()
            let house: PFGeoPoint = PFGeoPoint(latitude: 42.273898, longitude: -83.725722)
            //queryScope.whereKey("location", nearGeoPoint: house, withinMiles: 0.1)
            
            query.whereKey("location", nearGeoPoint: house, withinMiles: 0.1)
            //queries.addObject(queryScope)
        }
        /*
        if (![scope isEqualToString:@"All"]) {
            // Further filter the array with the scope
            NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
            tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
        }
        filteredCandyArray = [NSMutableArray arrayWithArray:tempArray];
        */
        
        
        query.findObjectsInBackgroundWithBlock({(NSMutableArray objects, NSError error) in
            if (error == nil) {
                NSLog("error " + error.localizedDescription)
            } else {
                self.searchResults = objects
                self.searchDisplayController.searchResultsTableView.reloadData()
            }
        })
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: NSString!) -> Bool {
//        self.filterContentForSearchText(searchString)
//        return true
        let scopes = self.searchDisplayController.searchBar.scopeButtonTitles as Array
        let selectedScope = scopes[self.searchDisplayController.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        self.filterContentForSearchText(self.searchDisplayController.searchBar.text)
//        return true
        let scopes = self.searchDisplayController.searchBar.scopeButtonTitles as Array
        self.filterContentForSearchText(self.searchDisplayController.searchBar.text, scope: scopes[searchOption] as NSString)
        return true
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        //self.performSegueWithIdentifier("memberSegue", sender: self)
        //self.searchDisplayController.setActive(false, animated: true)
    }

}
