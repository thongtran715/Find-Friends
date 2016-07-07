//
//  Meeting.swift
//  MapKitTutorial
//
//  Created by Julia Woodward on 7/7/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import Foundation
import UIKit

class ArrangeMeeting {
    
    var nameOfTopic: String!
    var date : String!
    var location : String!
    
    init(nameOfTopic: String, date: String, location: String)
    {
        self.nameOfTopic = nameOfTopic
        self.date = date
        self.location = location
    }
    
}
    