//
//  AutoSyncHealthDataModel.swift
//  QardiyoHF
//
//  Created by RAVI PATEL on 23/12/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Alamofire
import HealthKitUI


class AutoSyncHealthDataModel: NSObject {
    
   // var arraySource = [DeviceData]()
    
    
    func startSyncAfterInter(time:TimeInterval){
      //  syncHealthDataByTimeInterval()
        startSyncing()

   //  Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.startSyncing), userInfo: nil, repeats: true)
        
    }
    
    
     func startSyncing(){
        
        HealthkitQuery.queryData(completion: {
            (result,error) in
            //  SVProgressHUD.dismiss()
            
      //      self.arraySource = result!
            if (result == nil){
                return
            }
            for tempResutl in result!{
                self.submitStep(deviceData: tempResutl, completed: {
                    print("Data successFully sync")
            })
            
          //  if result!.count > 0 {
             //   self.submitStep(deviceData: result![0], completed: {
            //        print("Data successFully sync")
              //  })
            
            }
        })
        
        //    authenticationController = AuthenticationController(delegate: self)
    }
    
    
    
    func syncHealthDataByTimeInterval(){
         let healthStore = HKHealthStore()
         let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        func importStepsHistory() {
            let now = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: -30, to: now)!
            
            var interval = DateComponents()
            interval.day = 1
            
            var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
            anchorComponents.hour = 0
            let anchorDate = Calendar.current.date(from: anchorComponents)!
            
            let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                    quantitySamplePredicate: nil,
                                                    options: [.cumulativeSum],
                                                    anchorDate: anchorDate,
                                                    intervalComponents: interval)
            query.initialResultsHandler = { _, results, error in
                guard let results = results else {
                 //   log.error("Error returned form resultHandler = \(String(describing: error?.localizedDescription))")
                    return
                }
                
                results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                    if let sum = statistics.sumQuantity() {
                        let steps = sum.doubleValue(for: HKUnit.count())
                        print("Amount of steps: \(steps), date: \(statistics.startDate)")
                       
                       
                     let deviceData =   DeviceData.init(DeviceName: "iPhone", StepCount: steps, HeartRate: 0, Height: 0, Weight: 0)
                        
                        self.submitStep(deviceData: deviceData, completed: {
                           // print(completed)
                        })
                        
                    }
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    func saveToCoreData(deviceData:DeviceData){
        
        let newCondition = Condition(context: context)
        
        let heartRate = deviceData.HeartRate
        let weight = deviceData.Weight
        
        newCondition.dateToSort = Date() as NSDate?
        
        newCondition.bpm = "\(heartRate)"
        newCondition.date = getTodayString()
        newCondition.weigth = "\(weight)"
        newCondition.devicename = deviceData.DeviceName
        
        ad.saveContext()
    }
    
    
    func submitStep(deviceData:DeviceData,completed: @escaping DownloadComplete){
        //   SVProgressHUD.show()
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        //        dateFormatter.string(from: Date())
        let date = getTodayString()
        
        let dataUserDefault = UserDefaults.standard
        let token = dataUserDefault.object(forKey: "auth_token") as! String
        
        let parameters: Parameters = [
            "heart_rate": deviceData.HeartRate,
            "steps": deviceData.StepCount,
            "height": deviceData.Height,
            "weight": deviceData.Weight,
            "sleep_minutes": deviceData.Sleep,
            "created_at": date,
            "auth_token": token
        ]
        
        print(date)
        
        Alamofire.request("\(SYNC_URL)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(completionHandler: {
            response in
            if(response.result.isSuccess){
                let data = response.result.value as! Dictionary<String, Any>
                let status = data["status"] as? String ?? ""
                
                if status == "success" || status == "Success"{
                    //    let alert = UIAlertController(title: "Cardio", message: "Data has been synced successfully!", preferredStyle: .alert)
                    //   alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
                    self.saveToCoreData(deviceData:deviceData )
                    
                    //    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                //  self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
}


