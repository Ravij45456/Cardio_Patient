//
//  DeviceData.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-29.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation
import Alamofire
let FITBIT_WEB_API_LINK = "https://api.fitbit.com/1/user"

class DeviceData{
    private var _deviceName:String!
    private var _buldleID:String!
    private var _sourceName:String!
    private var _stepConut:Double!
    private var _heartRate:Double!
    private var _height:Double!
    private var _weight:Double!
    private var _sleep:Int!
    
    
    init(){
        _deviceName = ""
        _sourceName = ""
        _stepConut = 0
        _heartRate = 0
        _height = 0.0
        _weight = 0.0
        _buldleID = ""
        _sleep = 0
    }
    
    init(DeviceName:String, StepCount:Double, HeartRate:Double, Height:Double, Weight:Double){
        self.BundleID = ""
        self.DeviceName = DeviceName
        self.StepCount = StepCount
        self.Height = Height
        self.Weight = Weight
        self.HeartRate = HeartRate
    }
    
    init(DeviceName:String, StepCount:Double, HeartRate:Double, Height:Double, Weight:Double, Sleep:Int){
        self.BundleID = ""
        self.DeviceName = DeviceName
        self.StepCount = StepCount
        self.Height = Height
        self.Weight = Weight
        self.HeartRate = HeartRate
        self.Sleep = Sleep
    }
    
    public var DeviceName:String{
        get{return _deviceName}
        set{_deviceName = newValue}
    }
  
    public var SourceName:String{
        get{return _sourceName}
        set{_sourceName = newValue}
    }
    
    public var BundleID:String{
        get{return _buldleID}
        set{_buldleID = newValue}
    }
    
    public var StepCount:Double{
        get{return _stepConut}
        set{_stepConut = newValue}
    }

    public var Sleep:Int{
        get{return _sleep}
        set{_sleep = newValue}
    }
    
    public var HeartRate:Double{
        get{return _heartRate}
        set{_heartRate = newValue}
    }

    public var Height:Double{
        get{return _height}
        set{_height = newValue}
    }

    
    public var Weight:Double{
        get{return _weight}
        set{_weight = newValue}
    }
    
    static func getSleep(access_token:String, user_id:String , completed: @escaping (Int) -> Void){
        
//        GET https://api.fitbit.com/1.2/user/-/sleep/date/2017-04-02.json

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        
        
        let headers = [
            "Authorization": "Bearer \(access_token)"
        ]
        
        let url = URL(string: "\(FITBIT_WEB_API_LINK)/\(user_id)/sleep/date/\(currentDate).json")

        Alamofire.request(url!, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: {
            (response) in
            debugPrint(response)
            var totalSleep = 0
            
            let result = response.result.value as! [String: AnyObject]

            for (key, value) in result{
                if key == "summary" {
                    let items = value as! [String: AnyObject]

                    for (k, v) in items{
                        if k == "totalMinutesAsleep" {
                            totalSleep = v as? Int ?? 0
                        }
                    }
                }
            }

            completed(totalSleep)

        })
    }
    
    static func getStep(access_token:String, user_id:String , completed: @escaping (Double) -> Void){
        
        //        GET https://api.fitbit.com/1.2/user/-/sleep/date/2017-04-02.json
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        
        
        let headers = [
            "Authorization": "Bearer \(access_token)"
        ]
        
        let url = URL(string: "\(FITBIT_WEB_API_LINK)/\(user_id)/activities/date/\(currentDate).json")
        
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: {
            (response) in
            debugPrint(response)
            var totalStep = 0.0
            
            let result = response.result.value as! [String: AnyObject]
            
            for (key, value) in result{
                if key == "summary" {
                    let items = value as! [String: AnyObject]
                    
                    for (k, v) in items{
                        if k == "steps" {
                            totalStep = v as? Double ?? 0.0
                        }
                    }
                }
            }
            
            completed(totalStep)
            
        })
    }
    
    static func getHeartRate(access_token:String, user_id:String , completed: @escaping (Double) -> Void){
        
        //        GET https://api.fitbit.com/1.2/user/-/sleep/date/2017-04-02.json
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        
        
        let headers = [
            "Authorization": "Bearer \(access_token)"
        ]
        
        let url = URL(string: "\(FITBIT_WEB_API_LINK)/\(user_id)/activities/heart/date/\(currentDate)/\(currentDate).json")
        
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: {
            (response) in
            debugPrint(response)
            var total = 0.0
            
            let result = response.result.value as! [String: AnyObject]
            
            for (key, value) in result{
                if key == "activities-heart" {
                    for v in value as! [[String:Any]] {
                        for (k,v1) in v as [String: AnyObject] {
                            if k == "value" {
                                for (kk,vv) in v1 as! [String: AnyObject] {
                                    if kk == "restingHeartRate" {
                                        total = vv as? Double ?? 0.0
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            completed(total)
            
        })
    }
    
    static func getWeight(access_token:String, user_id:String , completed: @escaping (Double) -> Void){
        
        //        GET https://api.fitbit.com/1.2/user/-/sleep/date/2017-04-02.json
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        
        
        let headers = [
            "Authorization": "Bearer \(access_token)"
        ]
        
//        let url = URL(string: "\(FITBIT_WEB_API_LINK)/\(user_id)/body/log/fat/date/\(currentDate).json")
//
//        Alamofire.request(url!, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: {
//            (response) in
//            debugPrint(response)
//            var total = 0.0
//
//            let result = response.result.value as! [String: AnyObject]
//
//            for (key, value) in result{
//                if key == "fat" {
//                    let items = value as? [String: AnyObject]
//
//                    if items != nil {
//                        for (k, v) in items!{
//                            if k == "fat" {
//                                total = v as? Double ?? 0.0
//                                break
//                            }
//                        }
//                    }
//                }
//            }
//
//            completed(total)
//
//        })
        let url = URL(string: "\(FITBIT_WEB_API_LINK)/\(user_id)/profile.json")
        
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: {
            (response) in
            debugPrint(response)
            var total = 0.0
            
            let result = response.result.value as! [String: AnyObject]
            
            for (key, value) in result{
                if key == "user" {
                    let items = value as! [String: AnyObject]
                    
                    for (k, v) in items{
                        if k == "weight" {
                            total = v as? Double ?? 0.0
                            break
                        }
                    }
                }
            }
            
            completed(total)
            
        })
    }
    
    static func getHeight(access_token:String, user_id:String , completed: @escaping (Double) -> Void){
        
        //        GET https://api.fitbit.com/1.2/user/-/sleep/date/2017-04-02.json
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        let headers = [
            "Authorization": "Bearer \(access_token)"
        ]
        
        let url = URL(string: "\(FITBIT_WEB_API_LINK)/\(user_id)/profile.json")
        
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: {
            (response) in
            debugPrint(response)
            var total = 0.0
            
            let result = response.result.value as! [String: AnyObject]
            
            for (key, value) in result{
                if key == "user" {
                    let items = value as! [String: AnyObject]
                    
                    for (k, v) in items{
                        if k == "height" {
                            total = v as? Double ?? 0.0
                            break
                        }
                    }
                }
            }
            
            completed(total)
            
        })
    }
}
