//
//  LoginTableViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 26.04.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

class LoginTableViewController: UITableViewController {
    
    let scope = [VK_PER_WALL, VK_PER_PHOTOS, VK_PER_AUDIO, VK_PER_EMAIL]
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var aboutButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalStorage.userID = ""
        let sdkInstance : VKSdk = VKSdk.initializeWithAppId("5442423")
        sdkInstance.registerDelegate(self)
        sdkInstance.uiDelegate = self
        //VKSdk.forceLogout()
    }
    
    
    @IBAction func tryEnterWithEmail(sender: AnyObject) {}
    
    @IBAction func aboutButtonItem(sender: UIBarButtonItem) {}
    
    @IBAction func vkRegistration(sender: AnyObject) {
        VKSdk.wakeUpSession(scope, completeBlock: { state, error in
            if (state == VKAuthorizationState.Initialized) {
                VKSdk.authorize(self.scope)
            }
            if (state == VKAuthorizationState.Authorized) {
                let secondStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let next = secondStoryBoard.instantiateViewControllerWithIdentifier("vkAuthorizationTableViewController") as! VKAuthorizationTableViewController
                self.navigationController?.pushViewController(next, animated: true)
            } else if (error != nil) {
                print(error)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "loginToTimetableViewController") {
            if (userEmail.text == "") {
                let alert = UIAlertController(title: "Заполните поле email", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let actionOk = UIAlertAction(title: "Хорошо", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(actionOk)
                self.presentViewController(alert, animated: true, completion: nil)
            } else if (!Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}").test(userEmail.text!)) {
                let alert = UIAlertController(title: "Email введен неверно", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let actionOk = UIAlertAction(title: "Хорошо", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(actionOk)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                GlobalStorage.userEmail = userEmail.text!
            }
        }
    }
}

extension LoginTableViewController: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkNeedCaptchaEnter(captchaError: VKError) {}
    func vkSdkTokenHasExpired(expiredToken: VKAccessToken) {}
    func vkSdkUserDeniedAccess(authorizationError: VKError) {}
    func vkSdkShouldPresentViewController(controller: UIViewController) {
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func vkSdkReceivedNewToken(newToken: VKAccessToken) {}
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        if ((result.token) != nil) {
            print(result.token.accessToken)
            let secondStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let next = secondStoryBoard.instantiateViewControllerWithIdentifier("vkAuthorizationTableViewController") as! VKAuthorizationTableViewController
            self.navigationController?.pushViewController(next, animated: true)
        } else if ((result.error) != nil) {
            print("error")
        }
    }
    func vkSdkUserAuthorizationFailed() {}
}