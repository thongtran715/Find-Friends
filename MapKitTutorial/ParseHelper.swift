//
//  ParseHelper.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/8/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    static func getAllUsers(completionBlock: PFQueryArrayResultBlock) ->PFQuery {
        
        let query = PFUser.query()!
        query.whereKey("username", notEqualTo: (PFUser.currentUser()?.username!)!)
        query.orderByAscending("username")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completionBlock)
        return query
    }
    static func searchUsers(searchText: String, completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        /*
         NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
         Regex can be slow on large datasets. For large amount of data it's better to store
         lowercased username in a separate column and perform a regular string compare.
         */
        let query = PFUser.query()!.whereKey("username",
                                             matchesRegex: searchText, modifiers: "i")
        
        query.whereKey("username",
                       notEqualTo: PFUser.currentUser()!.username!)
        
        query.orderByAscending("username")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }

    
    
    
    
}
extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}