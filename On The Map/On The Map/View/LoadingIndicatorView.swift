//
//  LoadingIndicator.swift
//  On The Map
//
//  Created by Vinoth kumar on 6/4/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import UIKit
class LoadingIndicatorView: UIView {
    
    var loadingIndicatorWindow: UIWindow!
    @IBOutlet weak var imageView: UIImageView!
    
    class func fromNib() -> LoadingIndicatorView? {
        var view: LoadingIndicatorView?
        let nibViews = Bundle.main.loadNibNamed("LoadingIndicatorView", owner: nil, options: nil)
        for nibView in nibViews! {
            if (nibView as AnyObject).isKind(of:LoadingIndicatorView.self) {
                if let selectedView = nibView as? LoadingIndicatorView {
                    view = selectedView
                }
            }
        }
        return view
    }
    
    func show(){
        performUIUpdates {
            self.imageView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(.pi * 2.0)
            rotateAnimation.duration = 1.5
            rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
            
            self.imageView.layer.add(rotateAnimation, forKey: nil)
            let bounds = UIScreen.main.bounds
            let originX = (bounds.width - self.frame.width) / 2
            let originY = (bounds.height - self.frame.height) / 2
            let size = CGSize(width: self.frame.width, height: self.frame.height)
            let frame = CGRect(origin: CGPoint(x: originX, y: originY), size: size)
            self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)

            
            self.frame = frame
            
            
            self.loadingIndicatorWindow = UIWindow.init(frame: bounds)
            self.loadingIndicatorWindow.windowLevel = UIWindowLevelAlert
            self.loadingIndicatorWindow.isHidden = false
            
            self.loadingIndicatorWindow.addSubview(self)
            self.loadingIndicatorWindow.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        
        
    }
    func hide(){
        performUIUpdates {
            self.loadingIndicatorWindow.isHidden = true
            self.loadingIndicatorWindow = nil
        }
       
        
        
    }
    
}
