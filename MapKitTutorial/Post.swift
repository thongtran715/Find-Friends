import Foundation
import Parse

// 1
class Post : PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser?
    @NSManaged var nameFile : PFFile?
    @NSManaged var locationFile : PFFile?
    @NSManaged var dateFile : PFFile?
    @NSManaged var usersShare: PFUser?
    
    var waitingToUpload: UIBackgroundTaskIdentifier?
    var name : String!
    var location: String!
    var date : String!
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Post"
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
    
    func uploadFile() {
        
        if let name = name {
            guard let data = name.dataUsingEncoding(NSUTF8StringEncoding) else {return }
            guard let file = PFFile(name:"TopicName.txt", data:data) else {return }
            self.nameFile = file
            user = PFUser.currentUser()
            waitingToUpload = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                // 3
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }

            saveInBackgroundWithBlock(nil)
        }
        if let location = location
        {
            
            guard let data = location.dataUsingEncoding(NSUTF8StringEncoding) else {return }
            guard let file = PFFile(name:"LocationName.txt", data:data) else {return }
            self.locationFile = file
            user = PFUser.currentUser()
            waitingToUpload = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                // 3
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
        }
        if let date = date {
            
            guard let data = date.dataUsingEncoding(NSUTF8StringEncoding) else {return }
            guard let file = PFFile(name:"date.txt", data:data) else {return }
            self.dateFile = file
            user = PFUser.currentUser()
            waitingToUpload = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                // 3
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
        }
    
}
    
    
    
}