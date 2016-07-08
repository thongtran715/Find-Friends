//

import Foundation
import Parse

class userSharePost : PFObject, PFSubclassing {
    
    @NSManaged var toUser : PFUser?
    @NSManaged var fromPost: PFObject?
    
    var waitingToUpload: UIBackgroundTaskIdentifier?
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "userShare"
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
    
    
    
}