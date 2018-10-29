//
//  FingerPrintButton.swift
//  Swifty_Proteins
//
//  Created by Jeanette Henriette BURGER on 2018/10/26.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit

var isOn : Bool = false

class FingerPrintButton: UIButton {
//    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    //setup ui of button
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.twitBlue.cgColor
        layer.cornerRadius = frame.size.height/2
        
        setTitleColor(Colors.twitBlue, for: .normal)
        addTarget(self, action: #selector(FingerPrintButton.buttonPressed), for: .touchUpInside)
    }

    @objc func buttonPressed() {
        activateButton(bool: !isOn) // this means opposite is sent through to set to next value.
    }
    
    //toggle whether on or off
    func activateButton(bool: Bool) {
        isOn = bool
        
        let color = bool ? Colors.twitBlue : .clear
        let title = bool ? "Fingerprint" : "no fingerprint"
        let titleColor = bool ? Colors.twitBlue : .clear
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
    
}
