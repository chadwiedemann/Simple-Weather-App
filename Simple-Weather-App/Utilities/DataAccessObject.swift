//
//  DataAccessObject.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import CoreLocation

class DataAccessObject {
    
    static let sharedInstance = DataAccessObject()
    var currentLocation: Location?
    var savedLocations = [Location]()
    
    func saveCurrentLocation() {
        savedLocations.insert(currentLocation!, at: 0)
        let largestID = UserDefaults.standard.integer(forKey: "id")
        var locations = UserDefaults.standard.dictionary(forKey: "locations") ?? [String: Any]()
        locations["\(largestID)"] = createStringWithLocation((currentLocation?.coordinates)!)
        UserDefaults.standard.set((largestID + 1), forKey: "id")
        UserDefaults.standard.set(locations, forKey: "locations")
    }
    
    func loadSavedLocations() {
        guard let locations = UserDefaults.standard.dictionary(forKey: "locations") else{
            return
        }
        var myTupleArr = [(position: Int, cooridnate: CLLocationCoordinate2D)]()
        for location in locations{
            let newTuple = (Int(location.key)!, createLocationFromString(location.value as! String))
            myTupleArr.append(newTuple)
        }
        let sortedLocations = myTupleArr.sorted{ $0.position < $1.position }.map{ $0.cooridnate }
        let myNetworker = NetworkController()
        myNetworker.getWeatherForSavedLocations(sortedLocations, downloadCounter: 0)
    }
}
