//
//  GetForecastService.swift
//  WeatherForecast
//
//  Created by Natasha M on 03/02/18.
//  Copyright © 2016 Martinezpc. All rights reserved.
//

import Foundation
class GetForecastService : NetworkingManager {
    
    var latitude : String
    var longitude : String
    
    override func requestHeaders() -> [String:String]? {
        return nil
    }
    
    init(latitude : String, longitude: String ) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override func apiEndPoint() -> String {
        //personal
        return (URLSEndpoints.url.forecast + "620431612ff25cfbae5eb4caf22b61c5" + "/\(latitude),\(longitude)")
        //TODO1
        //        return (URLSEndpoints.url.forecast + "ea76e78f539ef7dae1879fd1a45d3628" + "/\(latitude),\(longitude)")
    }
}
