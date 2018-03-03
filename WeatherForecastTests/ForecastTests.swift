//
//  ForecastTests.swift
//  WeatherForecastTests
//
//  Created by Natasha Martinez on 3/2/18.
//  Copyright © 2018 Martinezpc. All rights reserved.
//

import XCTest
@testable import WeatherForecast

class ForecastTests: XCTestCase {

    var nullObject: Forecast!
    var incompleteObject: Forecast!
    
    override func setUp() {
        super.setUp()
        
        let daily = Daily(time: "", icon: "", tempMax: "", tempMin: "", tempAverage: "")

        nullObject = Forecast(timezone: "", currentTime: "", summary: "", icon: "", temperature: "", humidity: "", windSpeed: "", windBearing: "", dailyData: [daily])
        incompleteObject = Forecast(timezone: "America/Los_Angeles", currentTime: "1520043606", summary: "", icon: "default", temperature: "45.6", humidity: "0.0", windSpeed: "16", windBearing: "285", dailyData: [daily])
    }
    
    override func tearDown() {
        super.tearDown()
        
        nullObject = nil
        
        incompleteObject = nil
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
