//
//  HistoryViewController.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-22.
//  Edited by Jorge Gomez.
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import CoreData
import SwifterSwift
import Alamofire


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var constraintTopTableView: NSLayoutConstraint!
    @IBOutlet weak var numberOfSessionsLbl: UILabel!
  @IBOutlet weak var totalSessionsLabel: UILabel!
  @IBOutlet weak var displayAllButton: UIButton!
  @IBOutlet weak var totalSessionStackView: UIStackView!
  @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewGreen: UIView!
    var avgHeartRates: Int!
  var controller: NSFetchedResultsController<Condition>!
  @IBOutlet weak var tableViewTopSapce: NSLayoutConstraint!
  
  
  
    // MARK: Properties
  
    override func viewDidLoad() {
        super.viewDidLoad()
        displayAllButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        attemptFetch()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        //modify height of tableView
//        let modelName = UIDevice.current.modelName
        //print(modelName)
//        if(modelName == "iPhone 5s"){
//          tableViewTopSapce.constant = 10
//          tableView.updateConstraints()
//        }
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if screenWidth <= 320 {
            viewGreen.isHidden = false
        }else if screenWidth > 375 {
            self.constraintTopTableView.constant = 42
            self.view.layoutIfNeeded()
        }
        
        attemptFetch()
     }
  
    override func viewWillAppear(_ animated: Bool) {
      updateTotalHeartAverageLabel()
    }
    
    
    @IBAction func touchOnSyncButton(_ sender: Any) {
        self.performSegue(withIdentifier: "segueModalDevices", sender: nil)
        
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueModalDevices" {
            let vc = segue.destination as! UINavigationController
            vc.modalPresentationStyle = .overCurrentContext
            
            let topVC = vc.viewControllers.first as! ListDeviceViewController
            topVC.didSyncData = {
                self.updateTotalHeartAverageLabel()
            }
        }
    }

    // MARK: Actions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            numberOfSessionsLbl.text = "Total of \(sectionInfo.numberOfObjects) sessions"
            return sectionInfo.numberOfObjects
        }
        else{
          return 0
        }
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCustomCell
        cell.textLabel?.textColor = UIColor(red: 142.0/255.0, green: 184.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
    
        return cell
    }
    
    func configureCell(cell: HistoryCustomCell, indexPath: NSIndexPath){
        let condition = controller.object(at: indexPath as IndexPath)
        cell.configureCell(condition: condition)
      
    }
  
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)

            }
            break
        case.delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! HistoryCustomCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    
    }
    
    //Get all the heart rates and date stored in CoreData
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Condition> = Condition.fetchRequest()
        //sorting items in tableView
        let dateSort = NSSortDescriptor(key: "dateToSort", ascending: false)

        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
  

    func updateTotalHeartAverageLabel(){
      
       //let appDelegate = UIApplication.shared.delegate as! AppDelegate
      // let managedContext : NSManagedObjectContext = appDelegate.managedObjectContext!
      
        let fetchRequest: NSFetchRequest<Condition> = Condition.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        var averageTotal = 0
        do {
            let results = try context.fetch(fetchRequest)
            print("===\(results)")

            // Calculate the grand total...
          
            for order in results {
                var bpm = order.bpm?.int
                
                if bpm == nil {
                    bpm = Int((order.bpm?.float ?? 0)!)
                }
                
                averageTotal += bpm!
            }
            if(results.count > 0){
              totalSessionsLabel.text = "\(averageTotal/results.count)"
            } else {
              totalSessionsLabel.text = "0"
            }
          
          
        } catch let error as NSError {
            print(error)
        }
    }
}

