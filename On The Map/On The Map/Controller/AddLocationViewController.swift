//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Vinoth kumar on 29/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var urlTextField: UITextField!
    var loadingIndicatorView : LoadingIndicatorView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationTextField.delegate = self
        urlTextField.delegate = self
        loadingIndicatorView = LoadingIndicatorView.fromNib()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
       guard let location = locationTextField.text, !location.isEmpty,
        let url = urlTextField.text, !url.isEmpty else {
            return
        }
        
        if NetworkingManager.sharedInstance.isOffine {
            self.displayError("You are Offline. Please check your internet connection")
            
        } else {
            
            
            loadingIndicatorView.show()
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
            self.loadingIndicatorView.hide()
            guard error == nil else {
                 self.displayError("Invalid Location")
                return
            }
            guard placemark != nil else {
                 self.displayError("Location Not found")
                return
            }
            let addFinishVC = self.storyboard?.instantiateViewController(withIdentifier: "AddFinish") as! AddFinishViewController
            addFinishVC.mediaURL = url
            addFinishVC.mapString = placemark![0].name
            addFinishVC.placemark = placemark![0]
            self.navigationController?.pushViewController(addFinishVC, animated: true)
        }
        }
    }
   
}
