//
//  TipWebViewTableViewCell.swift
//  QardiyoHF
//
//  Created by Parmodh on 19/03/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class TipWebViewTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var webView: UIWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        
        // Initialization code
    }

   
}
