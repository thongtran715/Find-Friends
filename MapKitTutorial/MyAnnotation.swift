//
//  MyAnnotation.swift
//  MapKitTutorial
//
//  Created by Thong Tran on 7/6/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import Foundation
import MapKit

class MyAnnotation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}