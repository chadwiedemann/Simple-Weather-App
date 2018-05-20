//
//  Weather.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation

struct Weather {
    
    let temperature: Int
    let conditions: String
    let humidity: Int
    var weatherString: String {
        return "\(conditions)-\(temperature) degrees"
    }
    
    init(temp: Int, condition: String, humidity: Int) {
        self.temperature = temp
        self.conditions = condition
        self.humidity = humidity
    }
    
    static func createWeatherFromData(_ data: Data) -> Weather {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
            let mainInfo = parsedData["main"] as? [String:Any]
            let humidity = mainInfo!["humidity"] as? Int
            let temperature = mainInfo!["temp"] as? Double
            let weather = parsedData["weather"] as? [[String:Any]]
            let cond = weather?.first!["description"] as? String
            return Weather(temp: convertKelvinToFahreneheit(temperature!), condition: cond!, humidity: humidity!)
        } catch let error as NSError {
            print(error)
            return Weather(temp: 9, condition: "", humidity: 3)
        }
    }
}
