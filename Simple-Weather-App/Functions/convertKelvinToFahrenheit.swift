//
//  convertKelvinToFahrenheit.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation

func convertKelvinToFahreneheit(_ kelvin: Double) -> Int{
    let celsiusTemp = kelvin - 273.15
    let fahrenheitTemperature = celsiusTemp * 9 / 5 + 32
    return Int(fahrenheitTemperature)
}
