//
//  MyLocationAnnotation.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import MapKit

class MyLocationAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let conditions: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, conditions: String) {
        self.coordinate = coordinate
        self.title = title
        self.conditions = conditions
        super.init()
    }
    
    var subtitle: String? {
        return conditions
    }
    
}
