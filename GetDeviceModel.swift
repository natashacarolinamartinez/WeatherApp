//
//  GetDeviceModel.swift
//  WeatherForecast
//
//  Created by Natasha M on 03/02/18.
//  Copyright © 2016 Martinezpc. All rights reserved.
//

import Foundation
import DeviceKit

open class GetDeviceModel {
    
    func isthisAnIphone() -> Bool {
        let device = Device()
        if device.isPod {
            return false
        } else if device.isPhone {
            return true
        } else if device.isPad {
            return false
        }
        return false
    }
    
}
