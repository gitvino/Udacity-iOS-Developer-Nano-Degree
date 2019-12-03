//
//  UIViewControllerExtension.swift
//  On The Map
//
//  Created by Vinoth kumar on 16/4/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayError(_ displayMessage: String) -> Void {
        performUIUpdates {
            let alertController = UIAlertController(title: "Error", message: displayMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
