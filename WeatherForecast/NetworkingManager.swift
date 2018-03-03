//
//  NetworkingManager.swift
//  WeatherForecast
//
//  Created by Natasha M on 03/02/18.
//  Copyright © 2016 Martinezpc. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManager : NSObject {

    func getMainService(completion: @escaping ((_ retrieveData: NSDictionary?, _ error: NSError?, _ errorNonJson:NSError? ) -> Void)){
        var header = requestHeaders()
        if requestHeaders() != nil {
            header = requestHeaders()!
        }
        print("the url: \(URLSEndpoints.principal + apiEndPoint()!)")
        Alamofire.request(URLSEndpoints.principal + apiEndPoint()!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON {
            responseObject in switch responseObject.result {
            
        case .success(let JSONObject as NSDictionary):
            
            if responseObject.response?.statusCode == 200
            {
                completion(JSONObject, nil, nil)
                
            }
        case .failure(let error):
           print("Request failed with error: \(error)")
           completion(nil, error as NSError?, nil)
        default : break
            }
        }
    }
    
    func body() -> String {
        assert(false, "Method to be implemented by subclasses")
        return ""
    }
    
    func parameters() -> [String: AnyObject]? {
        
        assert(false, "Method to be implemented by subclasses")
        return nil
    }
    
    func requestHeaders() -> [String:String]? {
        
        assert(false, "Method to be implemented by subclasses")
        return nil
    }
    
    func apiEndPoint() -> String? {
        
        assert(false, "Method to be implemented by subclasses")
        return nil
    }
    
}
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
