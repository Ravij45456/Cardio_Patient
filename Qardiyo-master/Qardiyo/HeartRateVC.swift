//
//  HeartRateVC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-03-30.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class HeartRateVC: UIViewController {

    @IBOutlet weak var bpmImage: UIImageView!
    @IBOutlet weak var pulseNumberLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HeartRateVC.takePulse))
        self.startLabel.addGestureRecognizer(tapGesture)
      
        self.pulseNumberLabel.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(HeartRateVC.takePulse))
        self.pulseNumberLabel.addGestureRecognizer(tapGesture2)
      
        self.bpmImage.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(HeartRateVC.takePulse))
        self.bpmImage.addGestureRecognizer(tapGesture3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
        func takePulse(){
      self.performSegue(withIdentifier: "takePulse", sender: self)
    }
  
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
    

}
