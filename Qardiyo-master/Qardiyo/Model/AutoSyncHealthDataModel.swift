//
//  AutoSyncHealthDataModel.swift
//  QardiyoHF
//
//  Created by RAVI PATEL on 23/12/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Alamofire


class AutoSyncHealthDataModel: NSObject {
    
   // var arraySource = [DeviceData]()
    
    
    func startSyncAfterInter(time:TimeInterval){
        
        startSyncing()

     Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.startSyncing), userInfo: nil, repeats: true)
        
    }
    
    
     func startSyncing(){
        
        HealthkitQuery.queryData(completion: {
            (result,error) in
            //  SVProgressHUD.dismiss()
            
      //      self.arraySource = result!
            
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


