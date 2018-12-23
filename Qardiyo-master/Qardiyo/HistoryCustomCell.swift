//
//  HistoryCustomCell.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-01-09.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class HistoryCustomCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bloodPressureLabel: UILabel!
    
    
    @IBOutlet weak var viewCell: UIView!
    let greenQuardiyo = UIColor(hexString: "7BAB38")
    
    func configureCell(condition: Condition){
      viewCell.layer.cornerRadius = 10
      viewCell.addShadow(ofColor: greenQuardiyo!, radius: 10, offset: CGSize.zero, opacity: 1)
      viewCell.layer.masksToBounds = false
      
      if condition.bpm != nil {
            bpmLabel.text = "Heart rate: \(condition.bpm!) bpm"
        } else {
            bpmLabel.text = "Heart rate: N/A"
        }
        
        if condition.date != nil {

            dateLabel.text = "\(condition.date!)"
        } else {
            dateLabel.text = ""
        }
      
        if condition.weigth != nil{
          weightLabel.text = "Weight: \(condition.weigth!)"
        } else {
          weightLabel.text = "Weight: N/A"
        }
      
        if condition.devicename != nil {
            bloodPressureLabel.text = "Sync from: \(condition.devicename ?? "NA")"
        }else {
            if condition.bpDIA != nil, condition.bpSYS != nil {
              bloodPressureLabel.text = "Blood Pressure: \(condition.bpSYS!)/\(condition.bpDIA!)"
            } else {
              bloodPressureLabel.text = "Blood Pressure: N/A"
            }
        }
    }
}
