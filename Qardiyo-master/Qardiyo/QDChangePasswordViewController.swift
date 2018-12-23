//
//  QDChangePasswordViewController.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2018-01-10.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class QDChangePasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPasssword: UITextField!
    static func storyboardInstance() -> QDChangePasswordViewController? {
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "QDChangePasswordViewController") as? QDChangePasswordViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.isOpaque = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        mainView.layer.cornerRadius = 5
        mainView.layer.masksToBounds = true

        txtConfirmPassword.delegate = self
        txtNewPasssword.delegate = self
        txtOldPassword.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func touchOnOkButton(_ sender: Any) {
        if (txtOldPassword.text?.isEmpty)! {
            showMessage(msg: "Please input old password")
            return
        }

        if (txtNewPasssword.text?.isEmpty)! {
            showMessage(msg: "Please input new password")
            return
        }

//        if ((txtNewPasssword.text?.length)! < 6) {
//            showMessage(msg: "Password has to be at least 6 characters ")
//            return
//        }
        
        if txtNewPasssword.text == txtConfirmPassword.text{
            callChangePasswordAPI()
        }else{
            showMessage(msg: "New password dosen't match Re-type new password.\nPlease check try again!")
        }
    }
    
    @IBAction func touchOnCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showMessage(msg:String){
        let alert = UIAlertController(title: "Cardio", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
//            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func callChangePasswordAPI(){
        SVProgressHUD.show()
        
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") ?? ""

        
        let parameters: Parameters = [
            "auth_token": token,
            "password": txtOldPassword.text!,
            "new_password": txtNewPasssword.text!,
            "new_password_confirmation": txtConfirmPassword.text!
        ]
        
        Alamofire.request("\(CHANGE_PASSWORD)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(completionHandler: {
                response in
                debugPrint(response)
//                print(response)
                //if username and password is current enter statement
                if(response.result.isSuccess){
                    let data = response.result.value as! Dictionary<String, Any>
                    let status = data["status"] as? String ?? ""
                    
                    if status == "success" || status == "Success"{
                       
                        // save password to keychain
                        let username = UserDefaults.standard.value(forKey: username_keychain) as? String ?? ""
                       
                        do {
                            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                account: username,
                                                                accessGroup: KeychainConfiguration.accessGroup)
                        
                            // Save the password for the new item.
                            try passwordItem.savePassword(self.txtNewPasssword.text!)
                        }
                        catch {
                            //                        fatalError("Error reading password from keychain - \(error)")
                        }
                        
                        
                        
                        let alert = UIAlertController(title: "Cardio", message: "Your password has been changed successfully.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Confirmed!", style: .default) { action in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)

                    }else{
                        let alert = UIAlertController(title: "Error", message: "Cannot change your password.\nPlease check your current password and try again!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
                            
                        })
                        self.present(alert, animated: true, completion: nil)

                    }
                    SVProgressHUD.dismiss()
                } else {
                    
                    let alert = UIAlertController(title: "Error", message: "Cannot change your password.\nPlease check your current password and try again!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
                        
                    })
                    self.present(alert, animated: true, completion: nil)

                    SVProgressHUD.dismiss()
                }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
