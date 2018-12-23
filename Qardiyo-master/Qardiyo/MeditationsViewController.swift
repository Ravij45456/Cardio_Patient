//
//  MeditationsViewController.swift
//  QardiyoHF_Patient
//
//  Created by Ashish kumar patel on 14/07/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class MeditationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var meditations = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1)
        // Do any additional setup after loading the view.
        
        Messages.getMeditations(pid: "") { (meditation) in
            print(meditation)
            self.meditations = meditation.splitted(by: ",")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    //MARK: TableViewDelegate and Datasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  meditations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        cell?.textLabel?.text = meditations[indexPath.row]
        return cell!
    }
    
}
