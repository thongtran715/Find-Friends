//
//  MessageTableViewController.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/6/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Parse
import MapKit

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
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
          
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cellofNote", forIndexPath: indexPath) as! MessageTableViewCell
        let row = indexPath.row
        let fetch = posts[row]
        let topicData = try! fetch.nameFile?.getData()
        let dateData = try! fetch.dateFile?.getData()
        let locationData = try! fetch.locationFile?.getData()
        let creator = fetch.user?.username
        
        
        if row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 0.1)
        }else {cell.backgroundColor = UIColor.whiteColor()}
        
        tableView.rowHeight = 140
        
        if let topicData = topicData {
            cell.topicLabel.text = String(data: topicData, encoding: NSUTF8StringEncoding)}
        if let dateData = dateData{
            cell.dateLabel.text = String(data: dateData, encoding: NSUTF8StringEncoding)}
        if let locationData = locationData {
            cell.locationLabel.text = String(data: locationData, encoding: NSUTF8StringEncoding)}
        cell.creatorLabel.text = "Posted by: \(creator!)"
        
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
        let navigate = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Go There") { (action, index) in
            let fectching = self.posts[index.row]
            let data = try! fectching.locationFile!.getData()
            let dataString = String(data: data, encoding: NSUTF8StringEncoding)
            var addressofString = dataString!.componentsSeparatedByString(", ")
            addressofString.removeAtIndex(0)
            let getaddress = addressofString.joinWithSeparator(", ")
            let address = getaddress.stringByReplacingOccurrencesOfString("\n ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            print(address)
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if let placemark = placemarks!.first {
                    
                    let location = CLLocation(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                    
                                if placemark?.count > 0
                                {
                                    let pinForAppleMaps = placemark![0] as CLPlacemark
                                    print(pinForAppleMaps.subThoroughfare)
                                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: pinForAppleMaps.location!.coordinate, addressDictionary: pinForAppleMaps.addressDictionary as! [String:AnyObject]?))
                                    
                                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                    mapItem.openInMapsWithLaunchOptions(launchOptions)
                                }
                            }
                    
                    //self.presentViewController(vc, animated: true, completion: nil)
                  //self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                }
            })
            

        }
        navigate.backgroundColor = UIColor.greenColor()
        
        return [delete, navigate]
    }
}





