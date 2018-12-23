//
//  ListDeviceViewController.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-29.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        }

        if access_token.charactersArray.count > 0 && user_id.charactersArray.count > 0 {
            let fitBitDevice = DeviceData()
            
            var isDoneGetStep = false
            var isDoneGetHeartRate = false
            var isDoneGetHeight = false
            var isDoneGetWeight = false
            var isDoneGetSleep = false
            
            DeviceData.getStep(access_token: access_token, user_id: user_id, completed: {
                result in
                print("Step: \(result)")
                isDoneGetStep = true
                fitBitDevice.StepCount = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                }

            })

            DeviceData.getHeartRate(access_token: access_token, user_id: user_id, completed: {
                result in
                print("Heart Rate: \(result)")
                isDoneGetHeartRate = true
                fitBitDevice.HeartRate = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                }

            })
            
            DeviceData.getHeight(access_token: access_token, user_id: user_id, completed: {
                result in
                print("Height: \(result)")
                isDoneGetHeight = true
                fitBitDevice.Height = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                }

            })

            DeviceData.getWeight(access_token: access_token, user_id: user_id, completed: {
                result in
                print("Weight: \(result)")
                isDoneGetWeight = true
                fitBitDevice.Weight = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                }

            })

            DeviceData.getSleep(access_token: access_token, user_id: user_id, completed:{
                result in
                print("Sleep: \(result)")
                isDoneGetSleep = true
                fitBitDevice.Sleep = result
                
                if isDoneGetStep && isDoneGetHeartRate && isDoneGetHeight && isDoneGetWeight && isDoneGetSleep {
                    self.openSyncDeviceInfoVC(fitBitDevice: fitBitDevice)
                }

            })
            
            fitBitDevice.DeviceName = "Fitbit"
        }
//        print("access_token: \(access_token)  user_id: \(user_id)")
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
}
