//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Natasha M on 03/02/18.
//  Copyright © 2016 Martinezpc. All rights reserved.
//

import Foundation

class Forecast {
    var timezone : String
    var currentTime : String
    var summary : String
    var icon : String
    var temperature : String
    var humidity : String
    var windSpeed : String
    var windBearing : String
    var dailyData :  [Daily]
    
    init(timezone : String, currentTime : String, summary : String, icon : String, temperature: String, humidity : String, windSpeed : String, windBearing : String, dailyData :  [Daily]) {
        self.timezone = timezone
        self.currentTime = currentTime
        self.summary = summary
        self.temperature = temperature
        self.icon = icon
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.dailyData = dailyData
    }

}
