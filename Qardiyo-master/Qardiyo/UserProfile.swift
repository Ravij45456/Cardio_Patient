//
//  UserProfile.swift
//  Qardiyo HF
//
//  Created by Jorge Alejandro Gomez on 2017-05-18.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


class UserProfile {

 static func getUserProfile(completed: @escaping (Dictionary<String,Any>) -> Void){
    let dataUserDefault = UserDefaults.standard
    let token = dataUserDefault.object(forKey: "auth_token") as! String
  
    let parameters: Parameters = [
      "auth_token": token
    ]
    var userProfileInfo: Dictionary<String,Any> = [:]
    Alamofire.request("\(USER_PROFILE)", parameters: parameters).responseJSON { (response) in
      debugPrint(response)
      
      if let result = response.value as? Dictionary<String,Any> {
        if let weight = result["weight"] as? String {
          userProfileInfo["weight"] = weight
        } else {
          userProfileInfo["weight"] = "N/A"
        }
        
        if let weight_units = result["weight_units"] as? String {
          userProfileInfo["weight_units"] = weight_units
        } else {
          userProfileInfo["weight_units"] = "N/A"
        }
        
        if let height = result["height"] as? String {
          userProfileInfo["height"] = height
        } else {
           userProfileInfo["height"] = "N/A"
        }
        
        if let height_units = result["height_units"] as? String {
          userProfileInfo["height_units"] = height_units
        } else {
          userProfileInfo["height_units"] = "N/A"
        }
        
        if let user_id = result["public_pid"] as? String {
          userProfileInfo["public_pid"] = user_id
        } else {
          userProfileInfo["public_pid"] = "N/A"
        }
        
        if let user_age = result["age"] as? Int {
          userProfileInfo["age"] = user_age
        } else {
          userProfileInfo["age"] = "N/A"
        }
      }
      completed(userProfileInfo)
    }
 }
 
 
 static func saveDeviceToken(completed: @escaping DownloadComplete){
  let dataUserDefault = UserDefaults.standard
  let token = dataUserDefault.object(forKey: "auth_token") as! String
  var device_token = ""
  if let dev_token = dataUserDefault.object(forKey: "deviceTokenString") as? String {
    device_token = dev_token
  } else {
    device_token = ""
  }
  
  let parameters: Parameters = [
      "device_token": device_token,
      "auth_token": token
  ]

  Alamofire.request("\(DEVICE_TOKEN)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { (response) in
    debugPrint(response)
    completed()
  }
 }
 
 static func unregisterDeviceToken(completed: @escaping DownloadComplete){
  let dataUserDefault = UserDefaults.standard
  let token = dataUserDefault.object(forKey: "auth_token") as! String
  let device_token = dataUserDefault.object(forKey: "deviceTokenString") as? String
  
  let parameters: Parameters = [
    "device_token": device_token ?? "",
    "auth_token": token
  ]
  
  Alamofire.request("\(UNREGISTER_TOKEN)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { (response) in
      debugPrint(response)
      completed()
  }
 }
 
 static func changePassword(oldPassword: String, newPassword: String, confirmation: String, completed: @escaping ([String:Any])-> Void){
    let dataUserDefault = UserDefaults.standard
    let token = dataUserDefault.object(forKey: "auth_token") as! String
  
    print(oldPassword)
    print(newPassword)
    print(confirmation)
    let parameters: Parameters = [
      "auth_token": token,
      "password": oldPassword,
      "new_password": newPassword,
      "new_password_confirmation": confirmation
    ]
  
    let headers: HTTPHeaders = [
      "Accept": "application/json"
    ]
  
    var theResponse = [String:Any]()
  
    if Reachability.isConnectedToNetwork() {
      let url = URL(string: "\(CHANGE_PASSWORD)")
      Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
        debugPrint(response)
        
        let statusCode = response.response?.statusCode as! Int
        
          if statusCode == 200 {
            theResponse["statusCode"] = statusCode
          }
          if statusCode > 200 {
            
            theResponse["statusCode"] = statusCode
          }
        
          completed(theResponse)
        })
     } else {
          let alert = UIAlertController(title: "Error", message: "Check internet connection.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Close", style: .default) { action in })
          UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
  }
  
}

//  get the view controller from other classes such as UITableViewCells.
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
