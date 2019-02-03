//
//  WebViewController.swift
//  ParadigmServices
//
//  Created by Chetu on 25/04/18.
//  Copyright © 2018 Paradigm Services. All rights reserved.
//

import UIKit

class PSTermsAndCondictionsViewController: UIViewController,UIWebViewDelegate {

        @IBOutlet weak var WebView: UIWebView!
        // @IBOutlet weak var ContinuBtn: UIButton!
        @IBOutlet weak var TermsLabel: UILabel!
        @IBOutlet weak var SelectionBtn: UIButton!
        @IBOutlet weak var ContinuBtn: UIButton!
        var isFromHelpScreen = ""

        @IBOutlet weak var acceptbuttonConstantHeight: NSLayoutConstraint!

        @IBOutlet weak var webviewBottomConstant: NSLayoutConstraint!

        // MARK: viewSetup Initially
        /**
         @description: setup local properties and connect delagtes.
         @parameter: nill
         @returns: nill
         */
        override func viewDidLoad() {
                super.viewDidLoad()
                title = NSLocalizedString("Terms and condtion", comment: "")
            //    PSUtility.setBackArrow(controller: self)
                WebView.delegate = self
              //  checkSelectedCountry()
                //SelectionBtn.setTitle(NSLocalizedString("k_TermAndCondition", comment: ""), for: .normal)
            //    SelectionBtn.setImage(#imageLiteral(resourceName: "ic_checkbox_empty"), for: UIControlState.normal)
             //   SelectionBtn.setImage(#imageLiteral(resourceName: "ic_checkbox_selected"), for: UIControlState.selected)
            
            Messages.getPatientTermsAndCondition { (htmlString) in
                self.WebView.loadHTMLString(htmlString, baseURL: nil)
            }
        }

        func checkSelectedCountry() {
                        let url = Bundle.main.url(forResource: "doctorconsentform", withExtension:"html")
                        let request = URLRequest(url: url!)
                        WebView.loadRequest(request)
        }


        override func viewWillAppear(_ animated: Bool) {
                if SelectionBtn.isSelected == true {
                        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("k_Continue", comment: ""), style: .plain, target: self, action: #selector(continueButtonTapped))
                        //navigationItem.rightBarButtonItem?.tintColor = .white
                        self.ContinuBtn.isEnabled = true
                       // self.ContinuBtn.tintColor = UIColor.blue
                } else  {
                       //
                    self.ContinuBtn.isEnabled = true
                        //self.ContinuBtn.tintColor = .clear
                }
                navigationController?.setNavigationBarHidden(false, animated: true)
        }

        func Unsetbtn(){
                self.ContinuBtn.isEnabled = true
                self.ContinuBtn.tintColor = .clear
                //  self.TermsLabel.textColor = UIColor.black
               // SelectionBtn.setTitleColor(UIColor.blue, for: .normal)
        }

        // MARK: Continue Button
        /**
         @description: tap continue button function.
         @parameter: nill
         @returns: nill
         */
         @IBAction func continueButtonTapped() {
                print("Perform click event here")
               // self.performSegue(withIdentifier: "termAndConditionScreenSeque", sender: self)
            
           UserDefaults.standard.set(true, forKey: "isAgreeTerm")
            self.dismiss(animated: true, completion: nil)

        }

        func setbtn(){
                self.ContinuBtn.isEnabled = true
                self.ContinuBtn.tintColor = UIColor.init(hexString: "7ec4ce")
               // self.TermsLabel.textColor = UIColor.init(hexString: "7ec4ce")
            self.SelectionBtn.setImage(UIImage(named:"check_box"), for: .normal)
        }

        // MARK: RightBar button
        /**
         @description: change right bar button colour according to conditions.
         @parameter: nill
         @returns: nill
         */
        @IBAction func SelectBtnAction(_ sender: Any) {

                if SelectionBtn.isSelected == true {
                        Unsetbtn()
                        SelectionBtn.isSelected = false
                    self.SelectionBtn.setImage(UIImage(named:"check_box"), for: .normal)

                        navigationItem.rightBarButtonItem?.isEnabled = false
                        // navigationItem.rightBarButtonItem?.tintColor = .clear
                }
                else {
                        setbtn()
                        SelectionBtn.isSelected = true
                self.SelectionBtn.setImage(UIImage(named:"check_box"), for: .normal)

                        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("k_Continue", comment: ""), style: .plain, target: self, action: #selector(continueButtonTapped))
                        // navigationItem.rightBarButtonItem?.tintColor = .white
                }
        }
}
