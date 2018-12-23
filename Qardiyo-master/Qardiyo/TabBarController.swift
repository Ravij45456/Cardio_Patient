//
//  TabBarController.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-01-12.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 2
    }
  
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
