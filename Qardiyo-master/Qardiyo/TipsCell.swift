//
//  FAQCell.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-03-31.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class TipsCell: UITableViewCell {

  
  @IBOutlet weak var cellView: UIView!
  @IBOutlet weak var textLbl: UILabel!
  
  @IBOutlet weak var labelWidth: NSLayoutConstraint!
//  @IBOutlet weak var labelHeight: NSLayoutConstraint!
  
  let greenQuardiyo = UIColor(hexString: "7BAB38")
  
  func updateTipsTableView(tip: Tips){
      cellView.layer.cornerRadius = 10
      //cellView.addShadow(ofColor: greenQuardiyo!, radius: 10, offset: CGSize.zero, opacity: 1)
      cellView.layer.masksToBounds = false
      textLbl.text = tip.title
//      labelHeight.constant = 21
      textLbl.updateConstraints()
  }
  
  func updateFAQTableView(faq: FAQs){
    cellView.layer.cornerRadius = 10
    cellView.layer.masksToBounds = false
    labelWidth.constant = 307
    textLbl.text = faq.question + "\n" + faq.answer
    if(labelWidth.constant > 300){
//        labelHeight.constant = 50
        textLbl.numberOfLines = 3
    }
    textLbl.updateConstraints()
  }
}
