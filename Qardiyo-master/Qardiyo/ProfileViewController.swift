//
//  ProfileViewController.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-22.
//  Edited by Jorge Gomez
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController {

  @IBOutlet weak var heightLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  
  @IBOutlet weak var idLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserProfile.getUserProfile { (response) in
//            let age = response["age"] as! Int
//
//            let weight = response["weight"] as! String
//            let height = response["height"] as! String
//            let id = response["public_pid"] as! String
//
//            let w = Double(round(1000*Double(weight)!)/1000)
//
//            self.ageLabel.text = "Age: \(age.string)"
//            self.weightLabel.text = "Weight: \(w)"
//            self.heightLabel.text = "Height: \(height)"
//            self.idLabel.text = "ID: \(id)"
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserProfile.getUserProfile { (response) in
            let age = response["age"] as! Int
            
            let height = response["height"] as! String
            let id = response["public_pid"] as! String
            
            // Added by becase weight is null or n/a
            
            var w : Float = 0.0
            if let weight = response["weight"] as? Float{
                w = Float(Double(round(1000*Double(weight))/1000))
        }
            
            self.ageLabel.text = "Age: \(age.string)"
            self.weightLabel.text = "Weight: \(w)"
            self.heightLabel.text = "Height: \(height)"
            self.idLabel.text = "ID: \(id)"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchOnResetPassword(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main",bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordNavigationController") as? ResetPasswordNavigationController
//        let topVC = vc?.viewControllers.first! as! RequestPasswordTokenViewController
//        topVC.isReesetPassword = true
//
//        topVC.didResetPassword = {
//            self.logoutButton(UIButton())
//        }
//
//        self.present(vc!, animated: true, completion: nil)
        let vc = QDChangePasswordViewController.storyboardInstance()
        vc?.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: true, completion: nil)
    }
    
  @IBAction func logoutButton(_ sender: Any) {
      UserProfile.unregisterDeviceToken {
        let dataUserDefault = UserDefaults.standard
        dataUserDefault.set(nil , forKey: "autoLogin")
        dataUserDefault.set(nil, forKey: "auth_token")
        self.performSegue(withIdentifier: "goToLogin", sender: nil)
      }
  }
}
