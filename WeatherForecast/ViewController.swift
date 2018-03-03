//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Natasha M on 03/02/18.
//  Copyright © 2016 Martinezpc. All rights reserved.
//

import UIKit
import SwiftSpinner
import Foundation
import CoreLocation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var todayWebView: UIWebView!
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var windBearingIcon: UIImageView!
    @IBOutlet weak var windSpeedIcon: UIImageView!
    @IBOutlet weak var todayTemp: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var timezone: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windBearing: UILabel!
    @IBOutlet weak var humidityPercentage: UILabel!
    
    var locationManager = CLLocationManager()
    var controlFlag = false
    var forecastArray = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.prepareView()
        //        SwiftSpinner.show("Retrieving weather data...")
        self.retrieveForecast()
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        retrieveForecast()
    }
    
    func prepareView() {
        
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        locationManager.requestAlwaysAuthorization()
        
        let urlString = "https://source.unsplash.com/category/nature/\(1600)x\(900)"
        if let url = URL(string: urlString){
            getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else { print("url not found"); return  }
                DispatchQueue.main.async() { () -> Void in
                    self.backgroundImg.contentMode = .scaleAspectFill
                    self.backgroundImg.image =  UIImage(data: data)
                }
            }
        }

        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if !controlFlag {
            controlFlag = true
            retrieveForecast()
        }
    }
    
    func retrieveForecast() {
        
        forecastArray.removeAll()
        
        weekCollectionView.register(UINib(nibName: "collectionDayNib", bundle: nibBundle), forCellWithReuseIdentifier: "cell")
      
        var currentLocation = locationManager.location
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            
            if controlFlag {
                currentLocation = locationManager.location!
                
                locationManager.stopUpdatingLocation()
                
                SwiftSpinner.show("Retrieving weather data...")
                
                let getForecastService = GetForecastService(latitude: String(describing: currentLocation!.coordinate.latitude), longitude: String(describing: currentLocation!.coordinate.longitude))
                getForecastService.getMainService(completion: { (retrieveData, error, errorNonJson) in
                    SwiftSpinner.hide()
                    if (error != nil)
                    {
                        displayAlertMessage(viewController: self, message: "\(String(describing: error ))", sender: self.view)
                        return
                    }
                    
                    self.parseRetrievedData(retrievedData: retrieveData!)
                })
            }
        }else  {
            SwiftSpinner.hide()
            displayAlertMessage(viewController: self, message: "Please allow WeatherForecast to access your location in order to retrieve your local weather", sender: self.view)
        }
        
    }
    
    func updateViewData(){

        setImageWebView(fileName: forecastArray[0].icon, webView: todayWebView)
        
    let currentTime = forecastArray[0].currentTime
    self.date.text = "\(currentTime)"
    self.todayTemp.text = "\(forecastArray[0].temperature) º F"
    self.timezone.text = forecastArray[0].timezone
    self.humidityPercentage.text = "\(forecastArray[0].humidity) %"
    self.windSpeed.text = "\(forecastArray[0].windSpeed) MPH"
        let windDirection = Int(forecastArray[0].windBearing)!
        if windDirection > 0 && windDirection < 90 {
        self.windBearing.text = "NORTHEAST"
        } else if windDirection < 180 && windDirection > 90 {
        self.windBearing.text = "SOUTHEAST"
        } else if windDirection > 180 && windDirection < 270 {
        self.windBearing.text = "SOUTHWEST"
        }else if windDirection > 270 && windDirection < 360 {
        self.windBearing.text = "NORTHWEST"
        }else {
            switch windDirection {
            case 0:
                self.windBearing.text = "NORTH"
            case 360:
                self.windBearing.text = "NORTH"
            case 90:
                self.windBearing.text = "EAST"
            case 180:
                self.windBearing.text = "SOUTH"
            case 270:
                self.windBearing.text = "WEST"
            default:
                break
            }
        }
        weekCollectionView.reloadData()
        SwiftSpinner.hide()
    }
    
    func parseRetrievedData(retrievedData : NSDictionary) {
        
        var dailyArrayD = [Daily]()
        let timezone = String(describing: retrievedData.object(forKey: "timezone")!)
        let currentlyJson = retrievedData.object(forKey: "currently") as! NSDictionary
       
        let date = NSDate(timeIntervalSince1970: (currentlyJson.object(forKey: "time") as! TimeInterval))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "HH:mm"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        let currentTime = dateString
        let summary = String(describing: currentlyJson.object(forKey: "summary")!)
        let icon = String(describing: currentlyJson.object(forKey: "icon")!)
        let temperature = String(describing: currentlyJson.object(forKey: "temperature")!)
        let humidity = String(describing: currentlyJson.object(forKey: "humidity")!)
        let windSpeed = String(describing: currentlyJson.object(forKey: "windSpeed")!)
        let windBearing = String(describing: currentlyJson.object(forKey: "windBearing")!)
        let dailydictionary = retrievedData.object(forKey: "daily") as! NSDictionary
        let dailyArray = dailydictionary.object(forKey: "data") as! NSArray
        
        for i in 0..<dailyArray.count {
            
            let thisDay = dailyArray[i] as! NSDictionary
            
            let thisDate = NSDate(timeIntervalSince1970: (thisDay.object(forKey: "time") as! TimeInterval))
            let thisDayTimePeriodFormatter = DateFormatter()
            thisDayTimePeriodFormatter.dateFormat = "dd-MM"
            let thisDateString = thisDayTimePeriodFormatter.string(from: thisDate as Date)
            
            let time = thisDateString
            let tempMax = thisDay.object(forKey: "temperatureMax")! as! Double
            let tempMin = thisDay.object(forKey: "temperatureMin")! as! Double
            let tempAverage = String(describing: (((tempMax) + (tempMin) )/2))
            let day_icon = String(describing: thisDay.object(forKey: "icon")!)
            let dailyData = Daily(time: time, icon: day_icon, tempMax:  String(describing: tempMax), tempMin:  String(describing: tempMin) , tempAverage: tempAverage)
            dailyArrayD.append(dailyData)
        }
        
        let forecast = Forecast(timezone: timezone, currentTime: currentTime, summary: summary, icon: icon, temperature: temperature, humidity: humidity, windSpeed: windSpeed, windBearing: windBearing, dailyData: dailyArrayD)
        self.forecastArray.append(forecast)
        
        self.updateViewData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecastArray.count == 0 {
        return 0
        } else {
        return 5
        }
    }
    
    func setImageWebView(fileName: String, webView: UIWebView) {
        var path = ""
        
        if Bundle.main.path(forResource: fileName, ofType: "svg") != nil {
            
            path = Bundle.main.path(forResource: fileName, ofType: "svg")!
        } else {
           path = "default"
        }
        
        if path != "" {
            let fileURL:URL = URL(fileURLWithPath: path)
            let req = URLRequest(url: fileURL)
            webView.scalesPageToFit = false
            webView.loadRequest(req)
        }
        else {
            print("no filepath found!")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastCollectionCell
        let thisDayforecast = forecastArray[0].dailyData
        cell.day.text = thisDayforecast[indexPath.row].time
        cell.temperature.text = thisDayforecast[indexPath.row].tempAverage + " º F"
        setImageWebView(fileName: thisDayforecast[indexPath.row].icon, webView: cell.imageWebView)
        return cell
    }
    
}

