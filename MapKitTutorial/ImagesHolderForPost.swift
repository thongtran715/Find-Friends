//
//  ImagesHolderForPost.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/7/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import Foundation
import Parse

class imageHolder : PFObject, PFSubclassing {
    @NSManaged var imageFile: PFFile?
    @NSManaged var fromPost: PFObject?
    var getImage : UIImage?
    var waitingToUpload: UIBackgroundTaskIdentifier?
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "imageHolder"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    func uploadingPhoto () {
        
        if let getImage = getImage {
            guard let imageData = UIImageJPEGRepresentation(getImage, 0.8) else {return}
            guard let imageF = PFFile(name: "image.jpg", data: imageData) else {return}
            self.imageFile = imageF
           // self.fromPost = post
            // 1
            waitingToUpload = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
            
            // 2
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                // 3
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
        }
        
    }
    
    
}