//
//  createLocationFromString.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import CoreLocation

func createLocationFromString(_ myString: String) -> CLLocationCoordinate2D {
    let delimiter = ","
    let latitude = Double(myString.components(separatedBy: delimiter).first!)
    let longitude = Double(myString.components(separatedBy: delimiter)[1])
    return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
}
