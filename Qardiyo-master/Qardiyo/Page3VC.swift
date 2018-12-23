//
//  Page3VC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-04-27.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class Page3VC: UIViewController {

//  @IBOutlet weak var imageYposition: NSLayoutConstraint!
//  @IBOutlet weak var imageWidth: NSLayoutConstraint!
//  @IBOutlet weak var imageHeight: NSLayoutConstraint!
  @IBOutlet weak var iphoneImage: UIImageView!
  
  var newView : UIView!
  var background_blurr_view: UIView!
  var oldPasswordTextField: UITextField!
  var newPasswordTextField: UITextField!
  var confirmationTextField: UITextField!
  var titleLabel: UILabel!

  
  override func viewDidLoad() {
        super.viewDidLoad()
//        let modelName = UIDevice.current.modelName
        //print(modelName)
//        if(modelName == "iPhone 5s"){
//          imageYposition.constant = 20
//          imageHeight.constant = 422
//          imageWidth.constant = 222
//          iphoneImage.updateConstraints()
//        }
        // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
    func removePopUp(){
    SVProgressHUD.show()
    var mandatoryFields = [String]()
    
    if oldPasswordTextField.text == "" {
      mandatoryFields.append("Old password")
    }
    if newPasswordTextField.text == "" {
      mandatoryFields.append("New password")
    }
    if confirmationTextField.text == "" {
      mandatoryFields.append("Confirmation password")
    }
    
    if mandatoryFields.count == 0 {
      
      let old = oldPasswordTextField.text!
      let new = newPasswordTextField.text!
      let confirmation = confirmationTextField.text!
      
      UserProfile.changePassword(oldPassword: old, newPassword: new, confirmation: confirmation) { (response) in
        SVProgressHUD.dismiss()
        let alertController = UIAlertController(title: "New password!", message: "Your password has been updated successfully!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Continue", style: .default, handler: { (_) in
            UIView.animate(withDuration: 0.25, animations: {
            self.newView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.newView.alpha = 0
              }, completion:{(finished : Bool)  in
                  if (finished)
                  {
                      self.newView.removeFromSuperview()
                      self.background_blurr_view.removeFromSuperview()
                      let sb = UIStoryboard(name: "Main", bundle: nil)
                      let vc = sb.instantiateViewController(withIdentifier: "goToTabBar")
                      self.present(vc, animated: true, completion: nil)
                  }
          });
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
      }
    } else {
      var messageStrings = ""
      let counter = 0
      for field in 0 ... mandatoryFields.count-1 {
        if counter+1 == mandatoryFields.count {
          messageStrings += "\(mandatoryFields[field])."
        } else {
          messageStrings += "\(mandatoryFields[field]), "
        }
      }
      let alertController = UIAlertController(title: "Sorry", message: "Missing \(messageStrings)", preferredStyle: .alert)
      let ok = UIAlertAction(title: "Try again", style: .default, handler: { (_) in
        
      })
      alertController.addAction(ok)
      self.present(alertController, animated: true, completion: nil)
    }

  }
    

  @IBAction func closeButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
//    background_blurr_view = UIView(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width), height: (self.view.frame.height)))
//    background_blurr_view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//    newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-40, height: 300))
//    newView.frame = CGRect(x: 20, y: self.view.frame.height/2 - newView.frame.height/2, width: self.view.frame.width-40, height: 300)
//    newView.backgroundColor = UIColor(red: 198/255, green: 212/255, blue: 221/255, alpha: 0.93)
//    newView.layer.cornerRadius = 6
//    newView.alpha = 0
//    newView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//
//    //  OLD PASSWORD
//    oldPasswordTextField = UITextField(frame: CGRect(x: 15, y: 60, width: self.view.frame.width-70, height: 35))
//    oldPasswordTextField.placeholder = "Old password"
//    oldPasswordTextField.font = UIFont.systemFont(ofSize: 15)
//    oldPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
//    oldPasswordTextField.autocorrectionType = UITextAutocorrectionType.no
//    oldPasswordTextField.keyboardType = UIKeyboardType.default
//    oldPasswordTextField.returnKeyType = UIReturnKeyType.done
//    oldPasswordTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
//    oldPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//    oldPasswordTextField.isSecureTextEntry = true
//    newView.addSubview(oldPasswordTextField)
//
//    //  NEW PASSWORD
//    newPasswordTextField = UITextField(frame: CGRect(x: 15, y: 120, width: self.view.frame.width-70, height: 35))
//    newPasswordTextField.placeholder = "New password"
//    newPasswordTextField.font = UIFont.systemFont(ofSize: 15)
//    newPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
//    newPasswordTextField.autocorrectionType = UITextAutocorrectionType.no
//    newPasswordTextField.keyboardType = UIKeyboardType.default
//    newPasswordTextField.returnKeyType = UIReturnKeyType.done
//    newPasswordTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
//    newPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//    newPasswordTextField.isSecureTextEntry = true
//    newView.addSubview(newPasswordTextField)
//
//    //  CONFIRMATION
//    confirmationTextField = UITextField(frame: CGRect(x: 15, y: 180, width: self.view.frame.width-70, height: 35))
//    confirmationTextField.placeholder = "Confirm new password"
//    confirmationTextField.font = UIFont.systemFont(ofSize: 15)
//    confirmationTextField.borderStyle = UITextBorderStyle.roundedRect
//    confirmationTextField.autocorrectionType = UITextAutocorrectionType.no
//    confirmationTextField.keyboardType = UIKeyboardType.default
//    confirmationTextField.returnKeyType = UIReturnKeyType.done
//    confirmationTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
//    confirmationTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//    confirmationTextField.isSecureTextEntry = true
//    newView.addSubview(confirmationTextField)
//
//    titleLabel = UILabel()
//    titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 25)
//    titleLabel.frame = CGRect(x: 15, y: 15, width: self.view.frame.width-70, height: 35)
//    titleLabel.textAlignment = .center
//    titleLabel.font = UIFont(name: "Avenir Next-Medium", size: 17)
//    titleLabel.textColor = blueQardiyo
//    titleLabel.text = "Change password"
//    newView.addSubview(titleLabel)
//
//
//
//    let doneButton = UIButton()
//    doneButton.frame = CGRect(x: 0, y: 0, width: 61, height: 33)
//    doneButton.frame = CGRect(x: 15, y: 250, width: self.view.frame.width-70, height: 33)
//    doneButton.setTitle("Done", for: UIControlState.normal)
//    doneButton.setTitle("Done", for: UIControlState.highlighted)
//    doneButton.backgroundColor = greenQardiyo
//    doneButton.layer.cornerRadius = 6
//    doneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
//    doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
//
//    newView.addSubview(doneButton)
//    background_blurr_view.addSubview(newView)
//    doneButton.addTarget(self, action: #selector(self.removePopUp), for: .touchDown)
//    self.view.addSubview(self.background_blurr_view)
//
//
//    UIView.animate(withDuration: 0.25) {
//      self.newView.alpha = 1
//      self.newView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//    }

  
  }

}
