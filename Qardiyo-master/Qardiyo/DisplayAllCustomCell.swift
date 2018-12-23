//
//  DisplayAllCustomCell.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-01-19.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class DisplayAllCustomCell: UITableViewCell {


  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var bpmLabel: UILabel!
  @IBOutlet weak var bloodPressureLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!

  func configureCell(condition: Condition){
    
    if condition.date != nil {
      dateLabel.text = "\(condition.date!)"
    } else {
      dateLabel.text = "Date and time N/A"
    }
    
    if condition.bpm != nil {
      bpmLabel.text = "Heart rate: \(condition.bpm!) bpm"
    } else {
      bpmLabel.text = " N/A"
    }
    
    if condition.weigth != nil {
      weightLabel.text = "Weight: \(condition.weigth!)"
    } else {
      weightLabel.text = "N/A"
    }
    
    if condition.devicename != nil {
        bloodPressureLabel.text = "Sync from: \(condition.devicename ?? "NA")"
    }else {
        if condition.bpDIA != nil, condition.bpSYS != nil {
          bloodPressureLabel.text = "Blood Pressure - SYS: \(condition.bpSYS!) DIA: \(condition.bpDIA!)"
        } else {
          bloodPressureLabel.text = "Blood Pressure - N/A"
        }
    }
    
  }

}
