//
//  FingerPrintButton.swift
//  Swifty_Proteins
//
//  Created by Jeanette Henriette BURGER on 2018/10/26.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit
import LocalAuthentication

var isOn : Bool = false

class FingerPrintButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.twitBlue.cgColor
        layer.cornerRadius = frame.size.height/2
        layer.backgroundColor = Colors.twitBlue.cgColor
        setTitleColor(.white, for: .normal)
    }
}
