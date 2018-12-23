//
//  WelcomePagesVC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-04-27.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class WelcomePagesVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{

    let pages = ["Page1","Page2","Page3"]

    static func storyboardInstance() -> WelcomePagesVC? {
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "WelcomePagesVC") as? WelcomePagesVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
    override func viewDidAppear(_ animated: Bool) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "Page1")
      setViewControllers([vc!], // Has to be a single item array, unless you're doing double sided stuff I believe
                     direction: .forward,
                     animated: true,
                     completion: nil)
      
    }
  
    func pageViewController(_ pageViewController: UIPageViewController,
                        viewControllerBefore viewController: UIViewController) -> UIViewController? {
      if let identifier = viewController.restorationIdentifier {
          if let index = pages.index(of: identifier) {
              if index > 0 {
                  return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
              }
          }
      }
      return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
  
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
      return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
  
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      for view in view.subviews {
          if view is UIScrollView {
              view.frame = UIScreen.main.bounds
          }
          else if view is UIPageControl {
              view.backgroundColor = UIColor.clear
          }
      }
    }
}
