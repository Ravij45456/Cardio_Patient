//
//  MoreTableViewController.swift
//  QardiyoHF_Patient
//
//  Created by Ashish kumar patel on 13/07/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
 import SVProgressHUD


let dataUserDefaults = UserDefaults.standard

class MoreTableViewController: UITableViewController {
    var documents = [DocumentsModel]()
    var titleForDocument = ""
    var  patientProfileModel = PatientProfileModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set hardcode data for patient id
         dataUserDefaults.set("false", forKey: "ispasswordset")

     //   self.addButtonClicked()
       // dataUserDefaults.set("true", forKey: "ispasswordset")
      //  addButtonClicked()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataUserDefaults.object(forKey: "ispasswordset") as! String == "false"{
        self.addButtonClicked()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(withIdentifier: "SplashScreenViewController") as! SplashScreenViewController
        //self.window!.rootViewController = rootController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = rootController
    }
    
    @IBAction func consultAction(_ sender: UIButton) {
        titleForDocument = "Consults"
        getDocumentS(documentsType: "consults")
    }
    
    @IBAction func dignosticsAction(_ sender: UIButton) {
        titleForDocument = "Dignostics"
        getDocumentS(documentsType: "dignostics")
    }
    
    @IBAction func patientDemographicsAction(_ sender: UIButton) {
     //   titleForDocument = "Dignostics"
      // getPatientProfile()
    }
    
    
    func getDocumentS(documentsType:String){
    //    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        Messages.getDoucments(documentType: documentsType) { (documents) in
            DispatchQueue.main.async {
            //    hud.hide(animated: true)
                self.documents = documents
                self.performSegue(withIdentifier: "documentSequeIdentifier", sender: self)
            }
        }
    }
    
    func getPatientProfile(){
    //    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        Messages.getPatientProfile { (patinetProfile) in
                    DispatchQueue.main.async {
           //     hud.hide(animated: true)
                self.patientProfileModel = patinetProfile
                self.performSegue(withIdentifier: "demographicsSequeIdentifier", sender: self)
            }
        }
    }
    
    func addButtonClicked(){
        let alertController = UIAlertController(title: "EMR Authorization", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Password"
            textField.isSecureTextEntry = true
        }
        
        let saveAction = UIAlertAction(title: "Continue", style: .default, handler: { alert -> Void in
            if   let firstTextField = alertController.textFields{
                   let tempTextField = firstTextField[0]
            print("password \(String(describing: tempTextField.text))")
            
            if tempTextField.text == ""{
                let alertController = UIAlertController(title: "EMR Authorization", message: "Please Enter Valid Password", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action : UIAlertAction!) -> Void in
                    self.addButtonClicked()
                })
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
            
            SVProgressHUD.show()
                Messages.getPatientAuthorizationByPassword(password: tempTextField.text ?? "", completed: { (resultString) in
               SVProgressHUD.dismiss()

                if resultString == "false"{
                    let alertController = UIAlertController(title: "EMR Authorization", message: "Please Enter Valid Password", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action : UIAlertAction!) -> Void in
                        self.addButtonClicked()
                    })
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    dataUserDefaults.set("true", forKey: "ispasswordset")
                }
                
            })
            }
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in
            self.tabBarController?.selectedIndex = 2
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Navigation 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "documentSequeIdentifier" {
            let vc = segue.destination as! ConsultsListViewController
            vc.documents = self.documents
            vc.titleString = titleForDocument
        }else if(segue.identifier == "demographicsSequeIdentifier"){
            let vc = segue.destination as! DemographicsTableViewController
            vc.patientProfileModel = self.patientProfileModel
        }
    }
}
