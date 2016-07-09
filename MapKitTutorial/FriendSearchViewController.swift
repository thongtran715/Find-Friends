//
//  FriendSearchViewController.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/8/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Parse
protocol FriendSearchTableViewCellDelegate: class {
    func cell(cell: FriendSearchTableViewCell, didSelectFollowUser user: PFUser)
    func cell(cell: FriendSearchTableViewCell, didSelectUnfollowUser user: PFUser)
}
class FriendSearchViewController: UIViewController {

    var stringName  = [PFUser]()
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var post: Post? 
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
     var users: [PFUser]?
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            // you can use oldValue to access the previous value of the property
            oldValue?.cancel()
        }
    }
    
    // this view can be in two different states
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    // whenever the state changes, perform one of the two queries and update the list
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                query = ParseHelper.getAllUsers(updateList)
                
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                query = ParseHelper.searchUsers(searchText, completionBlock:updateList)
            }
        }
    }
    func updateList(results: [PFObject]?, error: NSError?) {
        self.users = results as? [PFUser] ?? []
        self.tableView.reloadData()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        state = .DefaultMode
    }


}
extension FriendSearchViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("userCell") as! FriendSearchTableViewCell
        let user = users![indexPath.row]
        cell.user = user
       cell.delegate = self
        return cell
    }
}

extension FriendSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ParseHelper.searchUsers(searchText, completionBlock:updateList)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Back"
        {
            var array = [String]()
            for user in stringName
            {
                array.append(user.username!)
            }
            let name = array.joinWithSeparator(", ")
            if let viewCol = segue.destinationViewController as? AddViewController
            {
                viewCol.nameOfUsers.text = name
                viewCol.arrayOfUsers = stringName
            }
        }
    }
    
    
    
    
    
}


extension FriendSearchViewController: FriendSearchTableViewCellDelegate {
    
    func cell(cell: FriendSearchTableViewCell, didSelectFollowUser user: PFUser) {
        //ParseHelper.setParseRelationshipBetweenUsers(post!, userShare: user)
        stringName.append(user)
    }
    
    func cell(cell: FriendSearchTableViewCell, didSelectUnfollowUser user: PFUser)
    {
        stringName.removeLast()
        
    }

    
}
