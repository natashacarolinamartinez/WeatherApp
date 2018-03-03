//
//  Daily.swift
//  WeatherForecast
//
//  Created by Natasha M on 03/02/18.
//  Copyright © 2016 Martinezpc. All rights reserved.
//

import Foundation

class Daily {

    var time : String
    var icon : String
    var tempMax : String
    var tempMin : String
    var tempAverage : String
    
    init(time : String, icon : String, tempMax: String, tempMin : String, tempAverage : String ) {
        self.time = time
        self.icon = icon
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.tempAverage = tempAverage
    }
}
