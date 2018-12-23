//
//  Utility.swift
//  prive
//
//  Created by Jason Lee on 2017-02-14.
//  Copyright © 2017 Jason Lee. All rights reserved.
//

import UIKit

class Utility: UIViewController {
    class func getCurrentViewController() -> UIViewController? {
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController!
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    // Returns the navigation controller if it exists
    class func getNavigationController() -> UINavigationController? {
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    static func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert);
        vc.present(alert, animated: true, completion: nil)
    }
}

