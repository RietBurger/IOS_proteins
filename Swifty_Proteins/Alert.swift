//
//  Alert.swift
//  Swifty_Proteins
//
//  Created by Lance CHANT on 2018/10/29.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    //to use this function showBasicAlert(on self, with "String", message "String)
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
