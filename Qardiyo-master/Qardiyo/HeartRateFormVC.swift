//
//  HeartRateFormVC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-03-08.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift
import CoreData
import Alamofire
import SVProgressHUD

class HeartRateFormVC: UIViewController {

  @IBOutlet weak var stackViewGeneral: UIStackView!
  @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
  @IBOutlet weak var stackViewWidth: NSLayoutConstraint!
  
  @IBOutlet weak var heartRateField: SkyFloatingLabelTextField!
  @IBOutlet weak var weightTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var sysTextField: SkyFloatingLabelTextField!
  @IBOutlet weak var diaTextField: SkyFloatingLabelTextField!

  @IBOutlet weak var weightTxtFieldHeight: NSLayoutConstraint!
  @IBOutlet weak var heartRateTextFieldHeight: NSLayoutConstraint!
  @IBOutlet weak var sysTextFieldHeight: NSLayoutConstraint!
  @IBOutlet weak var diaTextFieldHeight: NSLayoutConstraint!
  @IBOutlet weak var saveHeartRateBtn: UIButton!
  
  @IBOutlet weak var datePicker: UIDatePicker!
  var controller: NSFetchedResultsController<Condition>!
  
  
  override func viewDidLoad() {
      super.viewDidLoad()
      IQKeyboardManager.sharedManager().enableAutoToolbar = false
//      let modelName = UIDevice.current.modelName
      self.hideKeyboardWhenTappedAround()
//      if(modelName == "iPhone 5s"){
//          stackViewHeight.constant = 170
//          stackViewWidth.constant = 250
//          stackViewGeneral.updateConstraints()
//
//          heartRateField.font = UIFont(name: heartRateField.font!.fontName, size: 13)
//          weightTextField.font = UIFont(name: weightTextField.font!.fontName, size: 13)
//          sysTextField.font = UIFont(name: sysTextField.font!.fontName, size: 13)
//          diaTextField.font = UIFont(name: diaTextField.font!.fontName, size: 13)
//
//          weightTxtFieldHeight.constant = 35
//          heartRateTextFieldHeight.constant = 35
//          sysTextFieldHeight.constant = 35
//          diaTextFieldHeight.constant = 35
//
//          stackViewGeneral.spacing = 10.0
//        }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if SVProgressHUD.isVisible() {
      SVProgressHUD.dismiss()
    }
  }
  
  @IBAction func saveHeartRateBtn(_ sender: Any) {
      saveNewHeartRate {
        SVProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
      }
  }

  @IBAction func cancelBtn(_ sender: Any) {
    //dismiss view Controller
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func saveNewHeartRate(completed: @escaping DownloadComplete){
    if heartRateField.text != "" {

        //add new heart rate in CoreData
        let newCondition = Condition(context: context)
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        let dateTime = dateFormatter.string(from: datePicker.date)
        
        SVProgressHUD.show()

        let heartRate = heartRateField.text!
        let weight = weightTextField.text!
        let SYS = sysTextField.text!
        let DIA = diaTextField.text!

      
        newCondition.bpm = heartRate
        newCondition.date = dateTime
        newCondition.dateToSort = datePicker.date as NSDate?
      
        if diaTextField.text == "" {
          newCondition.bpDIA = "0"
        } else {
          newCondition.bpDIA = DIA
        }
        if sysTextField.text == "" {
          newCondition.bpSYS = "0"
        } else {
          newCondition.bpSYS = SYS
        }
        if weightTextField.text == ""{
          newCondition.weigth = "0"
        } else {
          newCondition.weigth = weight
        }
    
        //Saves in Qardiyo Backend
        HeartRate.saveManuallyEnteredData(heartRate: heartRate, weight: weight, SYS: SYS, DIA: DIA) {
          completed()
        }
      
    }
    else {
      //Message for user. Heart rate cannot be empty.
        SVProgressHUD.dismiss()
        
      let alert = UIAlertController(title: "Sorry", message: "Heart rate field cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
        
        })
        self.present(alert, animated: true, completion: nil)
    }
  }
  
  

}
