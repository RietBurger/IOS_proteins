//
//  loginViewController.swift
//  Swifty_Proteins
//
//  Created by Jeanette Henriette BURGER on 2018/10/26.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit
import LocalAuthentication

var active = true
    
class loginViewController: UIViewController {
        
    @IBOutlet weak var FingerBtnView: FingerPrintButton!
        
        let authContext = LAContext()
        let authReason = "Please use touch ID to login"
        var authError: NSError?
    
    
    @IBAction func fingerBtn(_ sender: Any) {
        //print("button pushed in loginViewController")
                    if active == true {
                        authenticateNow()
                    }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            authenticateUsingTouchID()
        }
        
        func authenticateUsingTouchID() {
            if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                FingerBtnView.initButton()
            } else {
                active = false
                //print(authError?.localizedDescription as Any)
            }
        }
        
        func authenticateNow() {
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: {(success, error) -> Void in
                if success {
                    //send to next UI
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "listView", sender: nil)
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            self.reportTouchIDError(error: error as NSError)
                        }
                    }
                }
            })
        }
        
        func reportTouchIDError(error: NSError) {
            switch error.code {
            case LAError.authenticationFailed.rawValue:
                print("Authentication failed")
            case LAError.passcodeNotSet.rawValue:
                print("passcode not set")
            case LAError.systemCancel.rawValue:
                print("authentication was cancelled by the system")
            case LAError.userCancel.rawValue:
                print("user cancel auth")
            case LAError.userFallback.rawValue:
                print("user tapped enter password")
            default:
                print(error.localizedDescription)
            }
        }
}
