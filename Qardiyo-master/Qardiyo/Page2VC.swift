//
//  Page2VC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-04-27.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class Page2VC: UIViewController {

//  @IBOutlet weak var imageYposition: NSLayoutConstraint!
//  @IBOutlet weak var imageWidth: NSLayoutConstraint!
//  @IBOutlet weak var imageHeight: NSLayoutConstraint!
  @IBOutlet weak var iphoneImage: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        let modelName = UIDevice.current.modelName
//        //print(modelName)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
