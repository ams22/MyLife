//
//  LoginTableViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 26.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var aboutButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalStorage.userID = ""
    }
    
    func returnIncorrectInputAlertController() {
        let incorrectInputAlert = UIAlertController(title: "Некорректный ввод", message: "Введите снова", preferredStyle: .Alert)
        let incorrectInputOkAction = UIAlertAction(title: "Хорошо", style: .Default, handler: nil)
        incorrectInputAlert.addAction(incorrectInputOkAction)
        self.presentViewController(incorrectInputAlert, animated: true, completion: nil)
    }
    
    func alert() {
        let alert = UIAlertController(title: "Необходим ваш id", message: "Поле для ввода", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Сохранить", style: .Default, handler: {
            (action: UIAlertAction) -> Void in
            let checkString = alert.textFields!.first!.text!
            if (Regex("[^0-9]").test(checkString)) {
                self.returnIncorrectInputAlertController()
            } else {
                let intInput = Int(checkString)
                if (intInput == 0) {
                    self.returnIncorrectInputAlertController()
                } else {
                    GlobalStorage.userID = alert.textFields!.first!.text!
                    self.performSegueWithIdentifier("LoginToVKTableViewController", sender: self)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .Default, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in }
        alert.addAction(action)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func aboutButtonItem(sender: UIBarButtonItem) {
    }
    
    @IBAction func vkRegistration(sender: AnyObject) {
        //self.performSegueWithIdentifier("LoginToVKTableViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoginToVKTableViewController") {
            if (GlobalStorage.userID.isEmpty) {
                alert()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}