//
//  SyncDeviceInfoViewController.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-29.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class SyncDeviceInfoViewController: UIViewController {

    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblStepCount: UILabel!
    @IBOutlet weak var lblHeartRate: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblSleep: UILabel!
    
    var deviceData:DeviceData!
    
    var didSyncData:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblDeviceName.text = deviceData.DeviceName
        lblStepCount.text = "\(deviceData.StepCount) Stp"
        lblHeartRate.text = "\(deviceData.HeartRate) bpm"
        lblHeight.text =  String(format:"%0.2f'",deviceData.Height)
            
        lblWeight.text = "\(deviceData.Weight) lbs"
        let hour:Int = deviceData.Sleep / 60
        let min:Int = deviceData.Sleep - hour * 60
        var strHour = "\(hour) hour"
        if (hour > 1) { strHour = strHour + "s"}
        var strMin = "\(min) min"
        if (min > 1) { strMin = strMin + "s"}
        
        lblSleep.text = strHour + " " + strMin
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchOnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func touchOnSync(_ sender: Any) {
        
        if deviceData.HeartRate <= 0 {
            let alert = UIAlertController(title: "Cardio", message: "Heart rate is zero.\nDo you want to sync data?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                self.submitStep(deviceData: self.deviceData, completed: {
                    SVProgressHUD.dismiss()
                    self.navigationController?.dismiss(animated: true, completion: {
                        self.didSyncData?()
                    })
                })

//                self.saveNewHeartRate(deviceData: self.deviceData, completed: {
//                    SVProgressHUD.dismiss()
//                    self.navigationController?.dismiss(animated: true, completion: {
//                        self.didSyncData?()
//                    })
//                })
            })
            alert.addAction(UIAlertAction(title: "No", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
        }else{
            self.submitStep(deviceData: self.deviceData, completed: {
                SVProgressHUD.dismiss()
                self.navigationController?.dismiss(animated: true, completion: {
                self.didSyncData?()
                })
            })
//            
//            self.saveNewHeartRate(deviceData: self.deviceData, completed: {
//                SVProgressHUD.dismiss()
//                self.navigationController?.dismiss(animated: true, completion: {
//                    self.didSyncData?()
//                })
//            })
        }
//        SVProgressHUD.show()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
//        
//        let date = dateFormatter.string(from: Date())
//        
//        let dataUserDefault = UserDefaults.standard
//        let token = dataUserDefault.object(forKey: "auth_token") as! String
//        
//        //POST to Qardiyo API - Submit Status
//        let parameters: Parameters = [
//            "heart_rate": deviceData.HeartRate,
//            "steps": deviceData.StepCount,
//            "height": deviceData.Height,
//            "weight": deviceData.Weight,
//            "created_at": date,
//            "auth_token": token
//        ]
//
//        Alamofire.request("\(SYNC_URL)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(completionHandler: {
//                response in
//                debugPrint(response)
//                //if username and password is current enter statement
//                if(response.result.isSuccess){
//                    let data = response.result.value as! Dictionary<String, Any>
//                    let status = data["status"] as? String ?? ""
//                    
//                    if status == "success" || status == "Success"{
//                        let alert = UIAlertController(title: "Qardiyo", message: "Data has been synced successfully!", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
//                            self.navigationController?.dismiss(animated: true, completion: nil)
//                        })
//                        self.present(alert, animated: true, completion: nil)
//                    }else{
//                        let alert = UIAlertController(title: "Error", message: "Cannot sync data.", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
//                            self.navigationController?.dismiss(animated: true, completion: {})
//                        })
//                    }
//                    SVProgressHUD.dismiss()
//                } else {
//                    //else display message to user
//                    
//                    let alert = UIAlertController(title: "Error", message: "Cannot sync data.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
//                        
//                    })
//                    SVProgressHUD.dismiss()
//                    self.present(alert, animated: true, completion: nil)
//                }
//        })
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
    
    func submitStep(deviceData:DeviceData,completed: @escaping DownloadComplete){
        SVProgressHUD.show()

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
                        let alert = UIAlertController(title: "Cardio", message: "Data has been synced successfully!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
                            self.saveToCoreData(deviceData:deviceData )
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Error", message: "Cannot sync data.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
                            self.navigationController?.dismiss(animated: true, completion: {})
                        })
                    }
                    SVProgressHUD.dismiss()
                } else {
                    //else display message to user

                    let alert = UIAlertController(title: "Error", message: "Cannot sync data.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in

                    })
                    SVProgressHUD.dismiss()
                    self.present(alert, animated: true, completion: nil)
                }
        })

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
    
    func saveNewHeartRate(deviceData:DeviceData,completed: @escaping DownloadComplete){
        //add new heart rate in CoreData
        let newCondition = Condition(context: context)

        SVProgressHUD.show()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        let dateTime = dateFormatter.string(from: Date())
        
        let heartRate = "\(deviceData.HeartRate)"
        let weight = "\(deviceData.Weight)"
        let SYS = "0"
        let DIA = "0"
       
        newCondition.bpm = heartRate
        newCondition.date = dateTime
        newCondition.dateToSort = Date() as NSDate
        
        newCondition.bpDIA = "0"
        newCondition.bpSYS = "0"
        newCondition.weigth = "0"
        newCondition.weigth = weight

        
        //Saves in Qardiyo Backend
        HeartRate.saveManuallyEnteredData(heartRate: heartRate, weight: weight, SYS: SYS, DIA: DIA) {
            completed()
        }
//            
//        }
//        else {
//            //Message for user. Heart rate cannot be empty.
//            let alert = UIAlertController(title: "Sorry", message: "Heart rate field cannot be empty", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
//                
//            })
//            self.present(alert, animated: true, completion: nil)
//        }
    }
}
