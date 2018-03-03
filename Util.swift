//
//  Util.swift
//  WeatherForecast
//
//  Created by Natasha M on 03/02/18.
//  Copyright © 2016 Martinezpc. All rights reserved.
//

import Foundation
import UIKit

func displayAlertMessage(viewController: UIViewController,message: String, sender: UIView){
    
    let alertController = UIAlertController(title: "WeatherForecast", message:
        message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,handler: nil))
    alertController.popoverPresentationController?.sourceView = sender
    alertController.popoverPresentationController?.sourceRect = sender.bounds
    alertController.view.tintColor = UIColor.init(netHex: 0x398ED4)
    viewController.present(alertController, animated: true, completion: nil)
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        completion(data, response, error)
        }.resume()
}
