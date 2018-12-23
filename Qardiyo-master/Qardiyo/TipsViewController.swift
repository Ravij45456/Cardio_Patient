//
//  TipsViewController.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-22.
//  Edited by Jorge Gomez
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import HMSegmentedControl
import Alamofire
import WebKit
import SVProgressHUD

class TipsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate  {

  @IBOutlet weak var segmentedAndBanner: UIStackView!
  @IBOutlet weak var segmentedControl: HMSegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  var tipsArray = [Tips]()
  var faqsArray = [FAQs]()
  var faq: FAQs!
  var tip: Tips!
  var webViewHeight:Int!
  var contentHeights : [CGFloat] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0]
  override func viewDidLoad() {
    super.viewDidLoad()
    SVProgressHUD.show()
    customizeSegmentedView()
    downloadTips {
      //SVProgressHUD.dismiss()
        SVProgressHUD.show()
      self.tableView.reloadData()
    }
    
    downloadFAQs {
      //SVProgressHUD.dismiss()
      self.tableView.reloadData()
    }
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 150
    tableView.register(UINib(nibName: "QDTipsCellTableViewCell", bundle: nil), forCellReuseIdentifier: "QDTipsCellTableViewCell")
    tableView.register(UINib(nibName: "TipWebViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TipWebViewTableViewCell")
   
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    let modelName = UIDevice.current.modelName
//    if(modelName == "iPhone 5s"){
//      var heightConstraint: NSLayoutConstraint
//      heightConstraint = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height , multiplier: 1, constant: 360)
//      tableView.addConstraint(heightConstraint)
//      tableView.updateConstraints()
//    }
  }
  
  func downloadTips(completed: @escaping DownloadComplete){
      //SVProgressHUD.show()
      let dataUserDefault = UserDefaults.standard
      let token = dataUserDefault.value(forKey: "auth_token")
      Alamofire.request("\(TIPS_URL)auth_token=\(token!)").responseJSON { response in
            debugPrint(response)
        
            if(response.result.isSuccess){
              let getTips = response.result.value as! Dictionary<String,[Dictionary<String, Any>]>
              let tips = getTips["tips"]!
              for tip in tips {
                let tipTitle = tip["title"]
                let tipId = tip["id"]
                let tipDate = tip["created_at"]
                
                let newTip = Tips(id: tipId as! String, title: tipTitle as! String, createdAt: tipDate as! String)
                self.tipsArray.append(newTip)
                self.tableView.reloadData()
                
              }
            }
            
      completed()
     }
    
  }
  
  func downloadFAQs(completed: @escaping DownloadComplete){
    //SVProgressHUD.show()
    let dataUserDefault = UserDefaults.standard
    let token = dataUserDefault.value(forKey: "auth_token")
    Alamofire.request("\(FAQ_URL)auth_token=\(token!)").responseJSON { response in
          debugPrint(response)
          //
          if(response.result.isSuccess){
            let getFAQs = response.result.value as! Dictionary<String,[Dictionary<String, Any>]>
            let faqs = getFAQs["faqs"]!
            for faq in faqs {
              let faqQuestion = faq["question"]
              let faqAnswer = faq["answer"]
              let faqId = faq["id"]
              let faqDate = faq["created_at"]
              
                let newFAQ = FAQs(id: faqId as! String, question: faqQuestion as! String, answer: faqAnswer as! String, createdAt: faqDate as! String, collapsed: false)
              self.faqsArray.append(newFAQ)
            }
          }
    completed()
   }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(segmentedControl.selectedSegmentIndex == 0){
      return tipsArray.count
    }
    else{
      return faqsArray.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
//    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TipsCell
     //let cell = Bundle.main.loadNibNamed("QDTipsCellTableViewCell", owner:self, options: nil)?.first as! QDTipsCellTableViewCell
    let cell = tableView.dequeueReusableCell(withIdentifier: "QDTipsCellTableViewCell") as! QDTipsCellTableViewCell
    if(segmentedControl.selectedSegmentIndex == 0){
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipWebViewTableViewCell") as! TipWebViewTableViewCell
       // let cell = Bundle.main.loadNibNamed("TipWebViewTableViewCell", owner:self, options: nil)?.first as!
        let currentTip = tipsArray[indexPath.row]
       
        var htmlString = currentTip.title
        htmlString = "<meta name='viewport' content='initial-scale=1.0, user-scalable=no' />" + htmlString
        let htmlHeight = contentHeights[indexPath.row]
        
        cell.webView.tag = indexPath.row
        cell.webView.delegate = self
        cell.webView.loadHTMLString(htmlString, baseURL: nil)
        cell.webView.frame = CGRect(x: 0, y: 0, width: cell.webView.frame.size.width, height: htmlHeight)
        return cell
    }
    
    if(segmentedControl.selectedSegmentIndex == 1){
       
      let currentFAQ = faqsArray[indexPath.row]
      cell.updateFAQTableView(faq: currentFAQ)
    }
   
    return cell
  }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            return contentHeights[indexPath.row]
        }else{
        return UITableViewAutomaticDimension
        }
        
    }
  func segmentedControlIndexChanged() {
    tableView.reloadData()
  }
  
 public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        //height = webView.scrollView.contentSize.height
        //tableView.reloadData()
        SVProgressHUD.dismiss()
        if (contentHeights[webView.tag] != 0.0)
        {
            // we already know height, no need to reload cell
            return
        }
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        webView.scrollView.isScrollEnabled = false;
        webView.scrollView.bounces = false;
        webView.scalesPageToFit = true;
        let currentTip = tipsArray[webView.tag]
        let tip = currentTip.title
        print("tag \(webView.tag) : Height \(webView.scrollView.contentSize.height)")
        if(tip.contains("iframe")){
        contentHeights[webView.tag] = (webView.scrollView.contentSize.height + 110)
        }else
        {
           contentHeights[webView.tag] = (webView.scrollView.contentSize.height + 50)
        }
        let indexPath = IndexPath(item: webView.tag, section: 0)
        tableView.reloadRows(at: [indexPath], with:UITableViewRowAnimation.automatic)
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
  func customizeSegmentedView(){
    segmentedControl.sectionTitles = ["Tip of the day"]
    segmentedControl.selectionIndicatorColor = UIColor(colorLiteralRed: 123/255, green: 171/255, blue: 56/255, alpha: 1.0)
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
    segmentedControl.backgroundColor = UIColor(colorLiteralRed: 25/255, green: 62/255, blue: 78/255, alpha: 1.0)
    segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    segmentedControl.addTarget(self, action: #selector(segmentedControlIndexChanged), for: UIControlEvents.valueChanged)
  
  }

}

public extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
//        case "iPod5,1":                                 return "iPod Touch 5"
//        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
//        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
//        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
//        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
//        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
//        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
//        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
//        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
//        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
//        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
//        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
//        case "AppleTV5,3":                              return "Apple TV"
//        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }

}
