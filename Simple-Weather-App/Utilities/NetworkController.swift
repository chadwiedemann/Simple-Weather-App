//
//  NetworkController.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkController {
    
    let dao = DataAccessObject.sharedInstance
    
    func getWeatherForCurrentLocation(_ location: CLLocationCoordinate2D) {
        let latitude = location.latitude.description
        let longitude = location.longitude.description
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&APPID=5901dff698d1ef0e03c9fe89c20e66df")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return }
            self.dao.currentLocation = Location.createLocationFromData(data)
            DispatchQueue.main.async {
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: NSNotification.Name(rawValue: "finishedAPICall"), object: nil)
            }
        }
        task.resume()
    }
    
    func getWeatherForSavedLocations(_ locations: [CLLocationCoordinate2D], downloadCounter: Int) {
        let location = locations[downloadCounter]
        let latitude = location.latitude.description
        let longitude = location.longitude.description
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&APPID=5901dff698d1ef0e03c9fe89c20e66df")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return }
            self.dao.savedLocations.insert(Location.createLocationFromData(data), at: 0)
            if self.dao.savedLocations.count == locations.count{
                DispatchQueue.main.async {
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.post(name: NSNotification.Name(rawValue: "finishedAPICallsForSavedLocations"), object: nil)
                }
            }else{
                self.getWeatherForSavedLocations(locations, downloadCounter: (downloadCounter + 1))
            }
        }
        task.resume()
    }
}
