//
//  ResetPasswordViewController.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-29.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    var isReesetPassword = false

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var comfirmPasswordTextField: UITextField!
    
    var didResetPassword:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        tokenTextField.delegate = self
        passwordTextField.delegate = self
        comfirmPasswordTextField.delegate = self 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchOnResetPassword(_ sender: Any) {
        
        if (emailTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "ID cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (tokenTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Token cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (passwordTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Password cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (comfirmPasswordTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "Comfrim password cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
            return
        }

        if (comfirmPasswordTextField.text != passwordTextField.text) {
            let alert = UIAlertController(title: "Error", message: "Password does not match the confirm password. ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
            return
        }

        SVProgressHUD.show()
        Alamofire.request("\(AUTH_PASSWORD_URL)resetpass?user_id=\(emailTextField.text!)&reset_token=\(tokenTextField.text!)&password=\(passwordTextField.text!)")
            .responseJSON { response in
                debugPrint(response)
                //if username and password is current enter statement
                if(response.result.isSuccess){
                    let data = response.result.value as! Dictionary<String, Any>
                    let status = data["status"] as? String ?? ""
                    
                    if status == "success" || status == "Success"{
                        let alert = UIAlertController(title: "Cardio", message: "Your password has been changed successfully!", preferredStyle: .alert)
                        
                        // save username and password to keychain
                        do {
                            UserDefaults.standard.setValue(self.emailTextField.text!, forKey: username_keychain)
                            
                            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                    account: self.emailTextField.text!,
                                                                    accessGroup: KeychainConfiguration.accessGroup)
                            
                            // Save the password for the new item.
                            try passwordItem.savePassword(self.passwordTextField.text!)
                        } catch {
                            fatalError("Error updating keychain - \(error)")
                        }

                        
                        alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
//                            self.navigationController?.popViewController(animated: true)

                            if self.isReesetPassword == true {
                                self.navigationController?.dismiss(animated: true, completion: {
                                    self.didResetPassword?()
                                })
                            }else{
                                self.navigationController?.dismiss(animated: true, completion: {})
                            }
                        })
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Error", message: "Invalid ID or token", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
                            
                        })
                    }
                    SVProgressHUD.dismiss()
                } else {
                    //else display message to user
                    
                    let alert = UIAlertController(title: "Error", message: "Invalid ID or token", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
                        
                    })
                    SVProgressHUD.dismiss()
                    self.present(alert, animated: true, completion: nil)
                }
        }

    }

    
    @IBAction func touchOnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITextFiedl Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
