//
//  createStringWithLocation.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import CoreLocation

func createStringWithLocation(_ location: CLLocationCoordinate2D) -> String {
    return "\(location.latitude),\(location.longitude)"
}
