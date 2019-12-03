//
//  LoginViewController.swift
//  On The Map
//
//  Created by Vinoth kumar on 24/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        containerViewTop.constant = (view.frame.height - containerView.frame.height) / 3
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChangeNotification), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func deviceOrientationDidChangeNotification(_ notification: Any) {
        containerViewTop.constant = (view.frame.height - containerView.frame.height) / 3
    }
    
    
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 10) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
   
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    @IBAction func loginPressed(_ sender: Any) {

        guard  !(userNameTextField.text?.isEmpty)! else {
            displayError("Username is empty")
            return
        }
        
        guard !(passwordTextField.text?.isEmpty)! else {
            displayError("Password is empty")
            return
        }
        
        let username = userNameTextField.text!
        let password = passwordTextField.text!
        UdacityClient.sharedInstance().loginTask(username: username, password: password) { (result, error) in
        
        if error != nil {
            self.displayError(error!.localizedDescription)
         }
        else {
              performUIUpdates {
              let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomePage")
               self.present(homeVC!, animated: true, completion: nil)
              }
           }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        return true
    }
}
