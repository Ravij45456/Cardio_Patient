//
//  ListDeviceViewController.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-29.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ListDeviceViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,AuthenticationProtocol {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var viewCenter: UIView!
    @IBOutlet weak var tableView: UITableView!
    
//    var arrayData = [DeviceData] = [DeviceData(DeviceName: "Apple Watch", StepCount: 100, HeartRate: 72, Height: 7, Weight: 120),
//                                  DeviceData(DeviceName: "Fitbit", StepCount: 10, HeartRate: 72, Height: 7, Weight: 120),
//                                  DeviceData(DeviceName: "iPhone 7", StepCount: 100, HeartRate: 72, Height: 7, Weight: 120),
//                                  DeviceData(DeviceName: "Fitbit Flex", StepCount: 100, HeartRate: 72, Height: 7, Weight: 120)]

    var arraySource = [DeviceData]()
    
    var didSyncData:(() -> Void)?

    var authenticationController: AuthenticationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewCenter.layer.cornerRadius = 5
        viewCenter.layer.masksToBounds = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        SVProgressHUD.setStatus("Searching Data Source")
        SVProgressHUD.show()
        
        HealthkitQuery.queryData(completion: {
            (result,error) in
            SVProgressHUD.dismiss()
            
            self.arraySource = result!
            
            let device = DeviceData()
            device.DeviceName = "Device Name"
            device.SourceName = "Source"
            
            self.arraySource.insert(device, at: 0)
            
            let fitBit = DeviceData()
            fitBit.DeviceName = "Fitbit"
            fitBit.SourceName = "Fitbit"
            self.arraySource.insert(fitBit, at: 1)

            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        })
        
        authenticationController = AuthenticationController(delegate: self)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchOnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arraySource.count <= 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "There are no available device or source."
            return cell

        }
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("ListDeviceTitleTableViewCell", owner: self, options: nil)?.first as! ListDeviceTitleTableViewCell
            cell.lblDevice.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.lblSource.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.lblDevice.textColor = lblTitle.textColor
            cell.lblSource.textColor = lblTitle.textColor
            
            cell.lblDevice.text = arraySource[indexPath.row].DeviceName
            cell.lblSource.text = arraySource[indexPath.row].SourceName
            cell.selectionStyle = .none
            return cell

        }else{
            let cell = Bundle.main.loadNibNamed("ListDeviceTableViewCell", owner: self, options: nil)?.first as! ListDeviceTableViewCell
            cell.lblDevice.textColor = lblTitle.textColor
            cell.lblSource.textColor = lblTitle.textColor
            
            cell.lblDevice.text = arraySource[indexPath.row].DeviceName
            cell.lblSource.text = arraySource[indexPath.row].SourceName
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < 1 {
            return
        }else if indexPath.row == 1 {
            // authen to fitbit web api
//            DispatchQueue.main.async {
//              
//            SVProgressHUD.setStatus("start syncing")
//            SVProgressHUD.show()
//            }
            authenticationController?.login(fromParentViewController: self)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SyncDeviceInfoViewController") as? SyncDeviceInfoViewController
        vc?.deviceData = arraySource[indexPath.row]
        
        vc?.didSyncData = {
            self.didSyncData?()
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
//        self.performSegue(withIdentifier: "seguePushSyncVC", sender: nil)
    }
    
    // MARK: AuthenticationProtocol
    
    var lastSycDate = ""
    
    func authorizationDidFinish(_ success: Bool,url: URL) {
        // parse url
       
        
        let strURL = url.absoluteString
        
        let arrayToken = strURL.components(separatedBy: "#")
        
        var access_token = ""
        var user_id = ""
        
        if arrayToken.count > 1{
            print("strURL: \(arrayToken[1])")
            let arrayElement = arrayToken[1].components(separatedBy: "&")
            
            for item in arrayElement {
                let arrayKeyAndValue = item.components(separatedBy: "=")
                if arrayKeyAndValue.count > 1{
                    if arrayKeyAndValue[0] == "access_token" {
                        access_token = arrayKeyAndValue[1]
                    }
                    if arrayKeyAndValue[0] == "user_id" {
                        user_id = arrayKeyAndValue[1]
                    }
                }
            }
          //  SVProgressHUD.dismiss()

        }
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        
        DispatchQueue.main.async {
           // SVProgressHUD.setStatus("Searching Data Source")
            SVProgressHUD.show()
        }

        
         var lastSycDate = "2019-01-01"
          if let getLastData  = UserDefaults.standard.value(forKey: "lastData") as? String{
            lastSycDate = getLastData
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: lastSycDate)
        
        for tempdate in  0...Date().days(sinceDate: date!)!{
                      var dateComponent = DateComponents()
          //  dateComponent.month = monthsToAdd
            dateComponent.day = tempdate
          //  dateComponent.year = yearsToAdd
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date!)
            fitBitSyncDayWise(access_token: access_token, user_id: user_id, date: futureDate!)
            
            sleep(1)
        }
        
       
        dateFormatter.string(from:date!)
         UserDefaults.standard.set( dateFormatter.string(from:date!), forKey: "lastData")
        
        
        

//        if access_token.charactersArray.count > 0 && user_id.charactersArray.count > 0 {
//            let fitBitDevice = DeviceData()
//
//            var isDoneGetStep = false
//            var isDoneGetHeartRate = false
//            var isDoneGetHeight = false
//            var isDoneGetWeight = false
//            var isDoneGetSleep = false
//
//            DeviceData.getStep(access_token: access_token, user_id: user_id, Date: <#Date#>, completed: {
//                result in
//                print("Step: \(result)")
//                isDoneGetStep = true
//                fitBitDevice.StepCount = result
//
//                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
//                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
//                }
//
//            })
//
//            DeviceData.getHeartRate(access_token: access_token, user_id: user_id, Date: <#Date#>, completed: {
//                result in
//                print("Heart Rate: \(result)")
//                isDoneGetHeartRate = true
//                fitBitDevice.HeartRate = result
//
//                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
//                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
//                }
//
//            })
//
//            DeviceData.getHeight(access_token: access_token, user_id: user_id, Date: <#Date#>, completed: {
//                result in
//                print("Height: \(result)")
//                isDoneGetHeight = true
//                fitBitDevice.Height = result
//
//                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
//                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
//                }
//
//            })
//
//            DeviceData.getWeight(access_token: access_token, user_id: user_id, Date: <#Date#>, completed: {
//                result in
//                print("Weight: \(result)")
//                isDoneGetWeight = true
//                fitBitDevice.Weight = result
//
//                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
//                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
//                }
//
//            })
//
//            DeviceData.getSleep(access_token: access_token, user_id: user_id, Date: <#Date#>, completed:{
//                result in
//                print("Sleep: \(result)")
//                isDoneGetSleep = true
//                fitBitDevice.Sleep = result
//
//                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
//                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
//                }
//
//            })
        
         //   fitBitDevice.DeviceName = "Fitbit"
        }
//        print("access_token: \(access_token)  user_id: \(user_id)")
    
    
    func  fitBitSyncDayWise(access_token: String, user_id:String, date:Date){
        
        
        
        if access_token.charactersArray.count > 0 && user_id.charactersArray.count > 0 {
            let fitBitDevice = DeviceData()
            
            var isDoneGetStep = false
            var isDoneGetHeartRate = false
            var isDoneGetHeight = false
            var isDoneGetWeight = false
            var isDoneGetSleep = false
            
            DeviceData.getStep(access_token: access_token, user_id: user_id, Date: date, completed: {
                result in
                print("Step: \(result)")
                isDoneGetStep = true
                fitBitDevice.StepCount = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                   // self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                     self.submitStep(deviceData: fitBitDevice, date: date)
                }
                
            })
            
            DeviceData.getHeartRate(access_token: access_token, user_id: user_id, Date: date, completed: {
                result in
                print("Heart Rate: \(result)")
                isDoneGetHeartRate = true
                fitBitDevice.HeartRate = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                   // self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                     self.submitStep(deviceData: fitBitDevice, date: date)
                }
                
            })
            
            DeviceData.getHeight(access_token: access_token, user_id: user_id, Date: date, completed: {
                result in
                print("Height: \(result)")
                isDoneGetHeight = true
                fitBitDevice.Height = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                  //  self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                     self.submitStep(deviceData: fitBitDevice, date: date)
                }
                
            })
            
            DeviceData.getWeight(access_token: access_token, user_id: user_id, Date: date, completed: {
                result in
                print("Weight: \(result)")
                isDoneGetWeight = true
                fitBitDevice.Weight = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                   // self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                     self.submitStep(deviceData: fitBitDevice, date: date)
                }
                
            })
            
            DeviceData.getSleep(access_token: access_token, user_id: user_id, Date: date, completed:{
                result in
                print("Sleep: \(result)")
                isDoneGetSleep = true
                fitBitDevice.Sleep = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                  //  self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                    self.submitStep(deviceData: fitBitDevice, date: date)
                }
                
            })
            fitBitDevice.DeviceName = "Fitbit"
    }
    }
    
    
    func openSyncDeviceInfoVC(fitBitDevice:DeviceData){
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SyncDeviceInfoViewController") as? SyncDeviceInfoViewController
        vc?.deviceData = fitBitDevice
        
        vc?.didSyncData = {
            self.didSyncData?()
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    // Added by Ravi for Syncing
    
    func submitStep(deviceData:DeviceData,date:Date){
        SVProgressHUD.show()
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        //        dateFormatter.string(from: Date())
        
      //  let date = getTodayString()
        
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
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Cardio", message: "Data has been synced successfully!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
                        self.saveToCoreData(deviceData:deviceData, date: date )
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Error", message: "Cannot sync data.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
                        self.navigationController?.dismiss(animated: true, completion: {})
                    })
                }
              //  SVProgressHUD.dismiss()
            } else {
                //else display message to user
                
                let alert = UIAlertController(title: "Error", message: "Cannot sync data.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
                    
                })
               // SVProgressHUD.dismiss()
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    func getTodayString(date:Date) -> String{
        
        let date = date
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
    
    func saveToCoreData(deviceData:DeviceData, date:Date){
        
        let newCondition = Condition(context: context)
        
        let heartRate = deviceData.HeartRate
        let weight = deviceData.Weight
        
        newCondition.dateToSort = Date() as NSDate?
        
        newCondition.bpm = "\(heartRate)"
        newCondition.date = getTodayString(date: date)
       //   newCondition.date = date
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

extension Date {
    
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
    
}
