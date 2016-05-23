//
//  TimeTableTableViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 29.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TimeTableTableViewController: UITableViewController {

    var plans = [NSManagedObject]()
    var managedContext = NSManagedObjectContext()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var timeTable: UITableView!
    
    @IBAction func addPlan(sender: AnyObject) {
        let alert = UIAlertController(title: "Новая заметка", message: "Введите текст заметки", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .Default, handler: {
            (action: UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.savePlan(textField!.text!)
            self.timeTable.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .Default, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func savePlan(plan: String) {
        let entity =  NSEntityDescription.entityForName("Note", inManagedObjectContext:managedContext)
        let timeTable = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Note
        timeTable.plans = plan
        timeTable.email = GlobalStorage.userEmail.lowercaseString
        //timeTable.setValue(plan, forKey: "plans")
        do {
            try managedContext.save()
            plans.append(timeTable)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deletePlan(index: Int) {
        let plan = plans[index]
        managedContext.deleteObject(plan)
        do {
            try managedContext.save()
            plans.removeAtIndex(index)
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    func updatePlan(index: Int) {
        let alert = UIAlertController(title: "Изменение заметки", message: "Введите текст заметки", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .Default, handler: {
            (action: UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.plans[index].setValue(textField!.text!, forKey: "plans")
            self.timeTable.reloadData()
            do {
                try self.managedContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .Default, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.text = self.plans[index].valueForKey("plans") as? String
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest(entityName: "Note")
        let resultPredicate1 = NSPredicate(format: "email = %@", GlobalStorage.userEmail.lowercaseString)
        fetchRequest.predicate = resultPredicate1
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            plans = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = timeTable.dequeueReusableCellWithIdentifier("Cell")
        let plan = plans[indexPath.row]
        
        cell!.textLabel!.text = plan.valueForKey("plans") as? String
       
        return cell!
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.deletePlan(indexPath.row)
            self.timeTable.reloadData()
        }
        delete.backgroundColor = UIColor.redColor()
        let update = UITableViewRowAction(style: .Normal, title: "Update") { action, index in
            self.updatePlan(indexPath.row)
            //self.timeTable.reloadData()
        }
        update.backgroundColor = UIColor.grayColor()
        return [delete, update]
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}