//
//  Location.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    
    var currentWeatherConditions: Weather?
    let name: String
    let coordinates: CLLocationCoordinate2D

    init(name: String, weather: Weather, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.currentWeatherConditions = weather
        self.coordinates = coordinate
    }
    
    static func createLocationFromData(_ data: Data) -> Location {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
            let locationName = parsedData["name"] as? String
            let coord = parsedData["coord"] as? [String:Any]
            let longitude = coord?["lon"] as? Double
            let latitude = coord?["lat"] as? Double
            let currentWeather = Weather.createWeatherFromData(data)
            return Location(name: locationName ?? "Unknown", weather: currentWeather, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!)))
        } catch let error as NSError {
            print(error)
            return Location(name: "Unkown Location", weather: Weather(temp: 3, condition: "", humidity: 4), coordinate: CLLocationCoordinate2D())
        }
    }
}
