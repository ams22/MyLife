//
//  VKAutorizationViewController.swift
//  MyLife
//
//  Created by Андрей Решетников on 20.05.16.
//  Copyright © 2016 mipt. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

class VKAutorizationViewController : UIViewController {
    
    let scope = [VK_PER_WALL, VK_PER_PHOTOS, VK_PER_AUDIO]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sdkInstance : VKSdk = VKSdk.initializeWithAppId("5442423")
        sdkInstance.registerDelegate(self)
        sdkInstance.uiDelegate = self
        VKSdk.wakeUpSession(scope, completeBlock: { state, error in
            if (state == VKAuthorizationState.Authorized) {
                print(VKSdk.accessToken().accessToken)
                let request: VKRequest = VKApi.requestWithMethod("audio.get", andParameters: ["owner_id": "56820028", "count": "3"])
                request.executeWithResultBlock(
                    {response in
                      print(response)
                    }, errorBlock: {error in
                        print(error)
                })
            } else if (error != nil) {
                
            }
        })
    }
    
    @IBAction func tryConnection(sender: AnyObject) {
        VKSdk.authorize(scope)
    }
    
}

extension VKAutorizationViewController: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkNeedCaptchaEnter(captchaError: VKError) {

    }
    func vkSdkTokenHasExpired(expiredToken: VKAccessToken) {
        
    }
    func vkSdkUserDeniedAccess(authorizationError: VKError) {
        
    }
    func vkSdkShouldPresentViewController(controller: UIViewController) {
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func vkSdkReceivedNewToken(newToken: VKAccessToken) {
        
    }
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        if ((result.token) != nil) {
            print(result.token.accessToken)
        } else if ((result.error) != nil) {
            print("error")
        }
    }
    func vkSdkUserAuthorizationFailed() {
        
    }
}
