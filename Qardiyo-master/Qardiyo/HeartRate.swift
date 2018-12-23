//
//  HeartRate.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-04-28.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import SwifterSwift
import SVProgressHUD


class HeartRate {
  
    //Access to CoreData
    var controller: NSFetchedResultsController<Condition>!
  
  
  
    //this function runs when heart rate is taken using the camera.
    static func saveNewData(){
      
            let dataUserDefault = UserDefaults.standard
            //let token = dataUserDefault.object(forKey: "auth_token")
            if let getBPM = dataUserDefault.object(forKey: "avgPulse") as? String, let getDateTime = dataUserDefault.object(forKey: "dateTime") as? String {
              
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
                let dateTypeDate = Date()
                let dateTime = getDateTime
                //print(dateTime)
              
                let newCondition = Condition(context: context)
                newCondition.measurementType = ""
                newCondition.mood = ""
                newCondition.notes = ""
                
                //weight, blood pressure info
                var getWeigth = dataUserDefault.object(forKey: "weigth") as? String
                var getBpDIA = dataUserDefault.object(forKey: "bpDIA") as? String
                var getBpSYS = dataUserDefault.object(forKey: "bpSYS") as? String
              
                let general = dataUserDefault.object(forKey: "General") as? String
                let resting = dataUserDefault.object(forKey: "Resting") as? String
                let preExercise = dataUserDefault.object(forKey: "PreExercise") as? String
                let postExercise = dataUserDefault.object(forKey: "PostExercise") as? String
                let maxHeartRate = dataUserDefault.object(forKey: "MaxHeartRate") as? String
                let additionalInfo = dataUserDefault.object(forKey: "additionalInfo") as? String
                let moodSlider = dataUserDefault.object(forKey: "mood") as? String
              
                if general == "Yes" {
                  newCondition.measurementType = "General"
                }
              
                if resting == "Yes" {
                  newCondition.measurementType = "Resting"
                }
              
                if preExercise == "Yes" {
                  newCondition.measurementType = "PreExercise"
                }
              
                if postExercise == "Yes" {
                  newCondition.measurementType = "PostExercise"
                }
              
                if maxHeartRate == "Yes" {
                  newCondition.measurementType = "MaxHeartRate"
                }
              
                if additionalInfo != "" {
                  newCondition.notes = additionalInfo
                }
              
                if getBPM != "" {
                  newCondition.bpm = getBPM
                }
              
                if getWeigth == "" {
                  getWeigth = "0"
                }
              
                if getBpDIA == "" {
                  getBpDIA = "0"
                }
              
                if getBpSYS == "" {
                  getBpSYS = "0"
                }
              
                //CoreData object attributes
                newCondition.date = "\(dateTime)"
                newCondition.dateToSort = dateTypeDate as NSDate?
                newCondition.weigth = getWeigth
                newCondition.bpDIA = getBpDIA
                newCondition.bpSYS = getBpSYS
                newCondition.mood = moodSlider
              
                let bpmInt = getBPM.int
                let weightInt = getWeigth?.int
                let bloodSYSInt = getBpSYS?.int
                let bloodDIAInt = getBpDIA?.int
                let moodSliderInt = Int(round((moodSlider?.float)!))
                let token = dataUserDefault.object(forKey: "auth_token") as! String
            
                
                //POST to Qardiyo API - Submit Status
                let parameters: Parameters = [
                  "heart_rate": bpmInt!,
                  "measurement_type": moodSlider!,
                  "notes": additionalInfo!,
                  "weight": weightInt!,
                  "blood_pressure_systolic": bloodSYSInt!,
                  "blood_pressure_diastolic": bloodDIAInt!,
                  "how_do_you_feel":moodSliderInt,
                  "auth_token": token
                ]
                
                Alamofire.request("\(HEART_RATE_SUBMIT)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(completionHandler: { (response) in
                  debugPrint(response)
                  let result = response.value as! Dictionary<String,String>
                  let status = result["status"]
                  if(status == "success"){
                      //save in CoreData as well
                      ad.saveContext()
                  }

                })
              
                dataUserDefault.set(nil, forKey: "avgPulse")
                dataUserDefault.set(nil, forKey: "dateTime")
                dataUserDefault.set(nil, forKey: "weigth")
                dataUserDefault.set(nil, forKey: "bpDIA")
                dataUserDefault.set(nil, forKey: "bpSYS")
            }
    }
  
    static func saveManuallyEnteredData(heartRate: String, weight: String, SYS: String, DIA: String, done: @escaping DownloadComplete){
      
        let dataUserDefault = UserDefaults.standard
        let token = dataUserDefault.object(forKey: "auth_token") as! String
      
        //POST to Qardiyo API - Submit Status
        let parameters: Parameters = [
          "heart_rate": heartRate,
          "measurement_type": 0,
          "notes": "N/A",
          "weight": weight,
          "blood_pressure_systolic": SYS,
          "blood_pressure_diastolic": DIA,
          "auth_token": token
        ]
        
        Alamofire.request("\(HEART_RATE_SUBMIT)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(completionHandler: { (response) in
          debugPrint(response)
          
          
          if let result = response.value as? Dictionary<String,String> {
            let status = result["status"]
            if(status == "success"){
                //save in CoreData as well
                ad.saveContext()
            }
          }
          done()
        })
    }
  
    static func averageHeartRate(completed: @escaping DownloadComplete){
      //Get history of Heart Rates from backend and calculate the average
      //Return string to UILabel 
//        let userDefaultsData = UserDefaults.standard
//        let token = userDefaultsData.object(forKey: "auth_token")
//        var avgHeartRate = 0
//        Alamofire.request("\(HEART_RATE_GET)?auth_token=\(token!)").responseJSON(completionHandler: { (response) in
//          debugPrint(response)
//          
//         
//        if let allHeartRates = response.result.value as? Dictionary<String,[Dictionary<String,Any>]> {
//          let histories = allHeartRates["history"]!
//          for heartRate in histories {
//            let heart_rate = heartRate["heart_rate"] as! Int
//            avgHeartRate = avgHeartRate + heart_rate
//          }
//          userDefaultsData.set(avgHeartRate, forKey: "avgHeartRate")
//         }
//         completed()
//        })
      
    }

}
