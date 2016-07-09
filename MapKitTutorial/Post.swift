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
    
    func uploadFile(completion: (success:Bool) -> Void) {
        if let name = name,  location = location, date = date  {
            guard let dataOfName = name.dataUsingEncoding(NSUTF8StringEncoding) else {return }
            guard let fileOfName = PFFile(name:"TopicName.txt", data:dataOfName) else {return }
            
            guard let dataOfDate = date.dataUsingEncoding(NSUTF8StringEncoding) else {return }
            guard let fileOfDate = PFFile(name:"date.txt", data:dataOfDate) else {return }
            guard let dataOFLocation = location.dataUsingEncoding(NSUTF8StringEncoding) else {return }
            guard let fileOfLocation = PFFile(name:"LocationName.txt", data:dataOFLocation) else {return }
            self.nameFile = fileOfName
             self.locationFile = fileOfLocation
            self.dateFile = fileOfDate

            user = PFUser.currentUser()
            waitingToUpload = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
            }
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                // 3
                UIApplication.sharedApplication().endBackgroundTask(self.waitingToUpload!)
                completion(success: success)
            }

        }
    
}
    
    
    
}