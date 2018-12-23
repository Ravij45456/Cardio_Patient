//
//  SelfAssessmentCell.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-02-16.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class SelfAssessmentCell: UITableViewCell {

  @IBOutlet weak var questionTextLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  
  
  func updateUI(questionText: String, answerText: String, questionNumber: Int){
    
    questionTextLabel.text = "\(questionNumber)) \(questionText)"
    
    if(answerText == "0"){
        answerLabel.text = "No"
    }
    else if(answerText == "1"){
      answerLabel.text = "Yes"
    }
    else {
      answerLabel.text = answerText
    }
    
  }

}
