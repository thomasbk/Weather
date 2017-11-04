//
//  Cities.swift
//  Weather
//
//  Created by Thomas Baltodano on 11/3/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

//import UIKit

//class Cities: NSObject {

//}

import Foundation
import Alamofire

class Cities {
    
    var _date: Double?
    
    var cod: String?
    var count: Int?
    var message: String?
    var cityList: Array<Any> = []
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    let appID = "a7bbbd5e82c675f805e7ae084f742024"
    let contCities = 10
    
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: _date!)
        return (_date != nil) ? "Today, \(dateFormatter.string(from: date))" : "Date Invalid"
    }
    
    
    
    func downloadData(latitude: Double, longitude: Double, completed: @escaping ()-> ()) {
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/find?lat=\(latitude)&lon=\(longitude)&cnt=\(contCities)&appid=\(appID)&units=metric")!
        print(url)
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            let result = response.result
            print("This is my result: \(result.value!)");
            
            if let dict = result.value as? JSONStandard,
                let cod = dict["cod"] as? String,
                let count = dict["count"] as? Int,
                let list = dict["list"] as? [JSONStandard],
                let message = dict["message"] as? String {
                
                self.cod = cod
                self.count = count
                self.message = message
                self.cityList = list
            }
            
            
            completed()
        })
    }
    
}
