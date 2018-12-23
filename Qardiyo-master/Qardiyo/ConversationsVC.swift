//
//  ConversationsVC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-05-03.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//999999
//TnbGkN1AjN

import UIKit
import SVProgressHUD

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var conversations = [String]()
    var participants = [[Dictionary<String,Any>]]()
    let cellIdentifier = "Conversations"
    var dataUserDefault = UserDefaults.standard
    var threadSelected: String!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(conversations.count)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        let indexPath = tableView.indexPath(for: cell)
        
        if phones.count > (indexPath?.row)!{
            if let phoneCallURL = URL(string: "tel://\(phones[(indexPath?.row)!])") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //get all mesages and performSegue
        SVProgressHUD.show()
        let currentThread = conversations[indexPath.row]
        threadSelected = currentThread
        
        //Added By Ravi
        Messages.getParticipants(threads: [currentThread]) { (response) in
            
            for tempResponse in response{
                var dicRespnse = tempResponse
                let userType = dicRespnse["user_type"] as! String
                if userType  == "0"{
                    self.dataUserDefault.set(tempResponse, forKey: "sender")
                }else{
                    self.dataUserDefault.set(tempResponse, forKey: "receiver")
                    self.dataUserDefault.set(tempResponse, forKey: "quick_blox_ids")
                    
                }
            }
            
            //     let senderName = response[1]["full_name"] as? String
            //            self.dataUserDefault.set(response[0], forKey: "sender")
            //            self.dataUserDefault.set(response[1], forKey: "receiver")
            //            self.dataUserDefault.set(response[1], forKey: "quick_blox_ids")
            //      Messages.getThreadMessages(thread: currentThread) { (response) in
            Messages.getUnreadMessages(thread: currentThread) { (response) in
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToConversation", sender: response)
            }
        }
        
        //      Messages.getThreadMessages(thread: currentThread) { (response) in
        //        Messages.getUnreadMessages(thread: currentThread) { (response) in
        //            SVProgressHUD.dismiss()
        //            self.performSegue(withIdentifier: "goToConversation", sender: response)
        
        //SS  above two lines were in the below method completion
        //        Messages.markThread(thread: currentThread, completed: {
        //          SVProgressHUD.dismiss()
        //          self.performSegue(withIdentifier: "goToConversation", sender: response)
        //        })
        
        //    }
        
    }
    var phones = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentThread = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath as IndexPath)
        Messages.getParticipants(threads: [currentThread]) { (response) in
            let senderName = response[1]["full_name"] as? String
            let doctor_user_id = response[1]["user_id"] as? String
            self.dataUserDefault.set(doctor_user_id, forKey: "doctor_user_id")
            self.phones.append((response[1]["phone"]  as? String) ?? "" )
            
            
            //        self.dataUserDefault.set(response[0], forKey: "sender")
            //        self.dataUserDefault.set(response[1], forKey: "receiver")
            //        self.dataUserDefault.set(response[1], forKey: "quick_blox_ids")
            
            DispatchQueue.main.async {
                cell.textLabel?.text = senderName
            }
        }
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! UINavigationController
        let targetController = controller.topViewController as! SupportViewController
        targetController.currentThread = threadSelected
        targetController.allMessages = sender as! [Messages]
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "goToTabBar") as! TabBarController
        self.present(homeVC, animated: true, completion: nil)
        
        
    }
    
    
}
