//
//  DemographicsTableViewController.swift
//  QardiyoHF_Patient
//
//  Created by Ravi on 15/07/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class DemographicsTableViewController: UITableViewController {
    
    @IBOutlet weak var allergiesLabel: UILabel!{
        didSet{
            allergiesLabel.text = "Allergies: \(patientProfileModel.allergies)"
        }
    }
    @IBOutlet weak var familyDoctorLabel: UILabel!{
        didSet{
            familyDoctorLabel.text = "Family Doctor: \(patientProfileModel.familyDoctor)"
        }
    }
    @IBOutlet weak var emergencyNumberLable: UILabel!{
        didSet{
            emergencyNumberLable.text = "Emergency No: \(patientProfileModel.emergencyNo)"
        }
    }
    
var patientProfileModel = PatientProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1)
        getPatientProfile()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
       // self.navigationController?.dismiss(animated: true, completion: nil)
      self.navigationController?.popViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(){
        allergiesLabel.text = "Allergies: \(patientProfileModel.allergies)"
        familyDoctorLabel.text = "Family Doctor: \(patientProfileModel.familyDoctor)"
        emergencyNumberLable.text = "Emergency No: \(patientProfileModel.emergencyNo)"
    }
    
    func getPatientProfile(){
        //    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        Messages.getPatientProfile { (patinetProfile) in
            DispatchQueue.main.async {
                //     hud.hide(animated: true)
                self.patientProfileModel = patinetProfile
                self.updateUI()
                //self.performSegue(withIdentifier: "demographicsSequeIdentifier", sender: self)
            }
        }
    }
}
