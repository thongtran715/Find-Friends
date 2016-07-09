//
//  FriendSearchTableViewCell.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/8/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Parse
class FriendSearchTableViewCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var sendMessageOutlet: UIButton!
    @IBAction func sendMessageButton(sender: AnyObject) {
        if let canAdd = canAdd where canAdd == true {
            delegate?.cell(self, didSelectFollowUser: user!)
            self.canAdd = false
        }
        else
        {
            delegate?.cell(self, didSelectUnfollowUser: user!)
            self.canAdd = true
        }
        
        
        
    }
    
   weak var delegate: FriendSearchTableViewCellDelegate?
    var canAdd: Bool? = true {
        didSet {
            /*
             Change the state of the follow button based on whether or not
             it is possible to follow a user.
             */
            if let canAdd = canAdd {
                sendMessageOutlet.selected = !canAdd
            }
        }
    }
    
    var user: PFUser? {
        didSet {
            userName.text = user?.username
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
