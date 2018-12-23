//
//  QDTipsCellTableViewCell.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2018-01-10.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import WebKit

class QDTipsCellTableViewCell: UITableViewCell,WKUIDelegate{

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblText: UILabel!
    
    
    //    let greenQuardiyo = UIColor(hexString: "7BAB38")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true

        
//        lblText.textColor = greenQuardiyo
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateTipsTableView(tip: Tips){
        //webView.loadHTMLString(tip.title, baseURL: nil)
        //lblText.text = tip.title
    }
    
    func updateFAQTableView(faq: FAQs){
        lblText.text = faq.question + "\n" + faq.answer
    }
    
}
