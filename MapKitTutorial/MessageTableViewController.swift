//
//  MessageTableViewController.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/6/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Parse
class MessageTableViewController: UITableViewController {

    var posts = [Post]()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromThisUser!])
        // 5
        query.includeKey("user")
        // 6
        query.orderByDescending("createdAt")
        
        // 7
        query.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            // 8
            self.posts = result as? [Post] ?? []
            // 9
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    @IBAction func unwindToMessageTableViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellofNote")!
        
        cell.textLabel!.text = "Post"
        
        return cell
    }
    
    @IBAction func unwindDoneMessageTableViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // Deleting the post
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete") { (action, index) in
        }
        delete.backgroundColor = UIColor.redColor()
        // Detail of the posts
        let detail = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Detail") { (action, index) in
            let fectching = self.posts[index.row]
            let data = try! fectching.locationFile!.getData()
            let dataString = String(data: data, encoding: NSUTF8StringEncoding)
                
        }
        detail.backgroundColor = UIColor.blueColor()
        
        return [delete, detail]
    }
}
