//
//  FAQViewController.swift
//  QardiyoHF
//
//  Created by Ashish kumar patel on 13/09/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Alamofire
import CollapsibleTableSectionViewController
import SVProgressHUD


class FAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , CollapsibleTableViewHeaderDelegate{
    
    var faqsArray = [FAQs]()

    @IBOutlet weak var tableView: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    func downloadFAQs(completed: @escaping DownloadComplete){
        //SVProgressHUD.show()
        let dataUserDefault = UserDefaults.standard
        let token = dataUserDefault.value(forKey: "auth_token")
        Alamofire.request("\(FAQ_URL)auth_token=\(token!)").responseJSON { response in
            debugPrint(response)
            SVProgressHUD.dismiss()

            //
            if(response.result.isSuccess){
                let getFAQs = response.result.value as! Dictionary<String,[Dictionary<String, Any>]>
                let faqs = getFAQs["faqs"]!
                for faq in faqs {
                    let faqQuestion = faq["question"]
                    let faqAnswer = faq["answer"]
                    let faqId = faq["id"]
                    let faqDate = faq["created_at"]
                    
                    let newFAQ = FAQs(id: faqId as! String, question: faqQuestion as! String, answer: faqAnswer as! String, createdAt: faqDate as! String, collapsed: true)
                    self.faqsArray.append(newFAQ)
                }
            }
            completed()
        }
    }

    
    //var sections = sectionsData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAQ"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1)
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        
      //  self.title = "FAQs"
        SVProgressHUD.show()

        downloadFAQs {

            //SVProgressHUD.dismiss()
            self.tableView.reloadData()
        }
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension FAQViewController {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return faqsArray.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return faqsArray[section].collapsed ? 0 : 1
       // return 1
    }
    
    // Cell
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        
       // let item: Item = sections[indexPath.section].items[indexPath.row]
        
      //  cell.nameLabel.text = faqsArray[indexPath.row].question
        cell.detailLabel.text = faqsArray[indexPath.row].answer
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Header
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = faqsArray[section].question
        header.arrowLabel.text = ">"
       header.setCollapsed(faqsArray[section].collapsed)
        header.section = section
       header.delegate = self
        
        return header
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
//     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1.0
//    }
    
}

//
// MARK: - Section Header Delegate
//
extension FAQViewController {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !faqsArray[section].collapsed
        
        // Toggle collapse
        faqsArray[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
