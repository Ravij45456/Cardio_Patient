//
//  ListDeviceTitleTableViewCell.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-31.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class ListDeviceTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblDevice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
