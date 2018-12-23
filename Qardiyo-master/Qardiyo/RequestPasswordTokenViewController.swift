//
//  RequestPasswordTokenViewController.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-29.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class RequestPasswordTokenViewController: UIViewController,UITextFieldDelegate {

    var isReesetPassword = false
    var didResetPassword:(() -> Void)?

    @IBOutlet weak var enailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isReesetPassword  == true {
            titleLabel.text = "Reset Password"
        }
        
        enailTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueEnterPasswordToken" {
            
            let toViewController = segue.destination as! ResetPasswordViewController
            
            toViewController.isReesetPassword = isReesetPassword
            
            toViewController.didResetPassword = {
                self.didResetPassword?()
            }
        }
    }
    
    @IBAction func touchOnRequestToken(_ sender: Any) {
        if(enailTextField.text != ""){
            SVProgressHUD.show()
            Alamofire.request("\(AUTH_PASSWORD_URL)forgotpass?user_id=\(enailTextField.text!)")
                .responseJSON { response in
                    debugPrint(response)
                    print(response)
                    //if username and password is current enter statement
                    if(response.result.isSuccess){
                        let data = response.result.value as! Dictionary<String, Any>
                        let status = data["status"] as? String ?? ""
                        
                        if status == "success" || status == "Success"{
                            let alert = UIAlertController(title: "Cardio", message: "Please check your registered E-mail. We have sent you reset password link in email.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss!", style: .default) { action in
                                self.navigationController?.popViewController(animated: true)
                            })
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "Error", message: "Invalid user", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
                                
                            })                            
                        }
                        SVProgressHUD.dismiss()
                    } else {
                        //else display message to user

                        let alert = UIAlertController(title: "Error", message: "Invalid user", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in

                        })
                        SVProgressHUD.dismiss()
                        self.present(alert, animated: true, completion: nil)
                    }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "ID cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            SVProgressHUD.dismiss()
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    @IBAction func touchOnCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {})
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
