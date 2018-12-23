//
//  DisplayAllVC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-01-18.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

//007
//ppDdatIZuH

import UIKit
import CoreData

class DisplayAllVC: UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {

  @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "displayCell"
    var controller: NSFetchedResultsController<Condition>!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptFetch()
    }
  
    // MARK: Actions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DisplayAllCustomCell
        
      configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
      
      return cell
    }
  
        func configureCell(cell: DisplayAllCustomCell, indexPath: NSIndexPath){
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
                let cell = tableView.cellForRow(at: indexPath) as! DisplayAllCustomCell
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
  
  

  @IBAction func backButtonPressed(_ sender: Any) {
  
    dismiss(animated: true, completion: nil)
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
  
  
}
