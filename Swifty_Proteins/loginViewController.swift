//
//  loginViewController.swift
//  Swifty_Proteins
//
//  Created by Jeanette Henriette BURGER on 2018/10/26.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit
import LocalAuthentication

class loginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        authenticateUsingTouchID()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        authenticateUsingTouchID()
    }
    
    func authenticateUsingTouchID() {
        let authContext = LAContext()
        let authReason = "Please use touch ID to login"
        var authError: NSError?
        
        // test if touch ID available
        //NOTE: this runs in private thread, not main thread!
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    
            
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: {(success, error) -> Void in
                if success {
                    print("authenticate")
                    //send to next UI
                    DispatchQueue.main.async {
//                        self.tabBarController?.selectedIndex = 2 // not working yet...
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
        } else {
            //this means touch id not available
            print(authError?.localizedDescription)
            //show normal signup screen
        }
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
//        case kLAErrorBiometryNotEnrolled:
//            print("user hasn't enrolled any finger with touch id")
//        case kLAErrorBiometryNotAvailable:
//            print("touch id is not available")
        case LAError.userFallback.rawValue:
            print("user tapped enter password")
        default:
            print(error.localizedDescription)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
