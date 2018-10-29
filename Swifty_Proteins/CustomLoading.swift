//
//  CustomLoading.swift
//  Swifty_Proteins
//
//  Created by Lance CHANT on 2018/10/29.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class CustomLoading: UIView {

    static let instance = CustomLoading()
    
    lazy var transparent:UIView = {
       let transparentView = UIView(frame: UIScreen.main.bounds)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        transparentView.isUserInteractionEnabled = false
        return transparentView
    }()
    
    lazy var GIF: UIImageView = {
       let GIFimage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        GIFimage.contentMode = .scaleAspectFit
        GIFimage.center = transparent.center
        GIFimage.isUserInteractionEnabled = false
        GIFimage.loadGif(name: "WeThinkCode-South-Africa")
//        GIFimage = UIImage.gif(name: "WeThinkCode-South-Africa")
//        GIFimage.loadGif(name: "WeThinkCode-South-Africa")
        return GIFimage
    }()
    
    func showGif() {
        self.addSubview(transparent)
        self.transparent.addSubview(GIF)
        self.transparent.bringSubview(toFront: self.GIF)
        UIApplication.shared.keyWindow?.addSubview(transparent)
    }
    
    func HideGIf() {
        self.transparent.removeFromSuperview()
    }

}
