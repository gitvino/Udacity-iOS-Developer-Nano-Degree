//
//  BaseViewController.swift
//  TwitterFly
//
//  Created by Vinoth on 7/9/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func displayError(error: NSError) {
        DispatchQueue.main.async {
            self.displayErrorBanner(error: error)
        }
        
    }
    
     fileprivate func displayErrorBanner(error: NSError)  {
        let errorView = UIView(frame: CGRect(x: 0,
                                             y: ((self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.height)!),
                                             width: UIScreen.main.bounds.width,
                                             height: 50))
        errorView.tag = 1
        let errorLabel = UILabel(frame: CGRect(x: 10,
                                               y: 0,
                                               width: UIScreen.main.bounds.width - 20,
                                               height: 50))
        errorLabel.text = error.localizedDescription
        errorLabel.textColor = UIColor.white
        errorLabel.numberOfLines = 2
        
        let closeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50,
                                                 y: 0,
                                                 width: 50,
                                                 height: 50))
        closeButton.addTarget(self, action: #selector(self.closeClicked(button:)), for: UIControlEvents.touchUpInside)
        closeButton.setTitle("\u{2573}", for: UIControlState.normal)
        closeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        errorView.addSubview(closeButton)
        errorView.addSubview(errorLabel)
        errorView.backgroundColor = UIColor.darkGray
        errorView.alpha = 0
        self.view.addSubview(errorView)
        UIView.animate(withDuration: 0.3, animations: {
            errorView.alpha = 1
        }, completion: nil)
        
        
    }
    fileprivate func removeErrorBanner(_ eachView: UIView) {
        if eachView.tag == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                eachView.alpha = 0
            }) { (_) in
                eachView.removeFromSuperview()
            }
        }
    }
    
    @objc func closeClicked(button: UIButton){
        
        for eachView in view.subviews {
            removeErrorBanner(eachView)
        }
    }

}
