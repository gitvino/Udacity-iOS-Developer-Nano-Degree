//
//  ComposeViewController.swift
//  TwitterFly
//
//  Created by Vinoth on 26/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit

class ComposeViewController: BaseViewController, UITextViewDelegate, DraftsViewDelegate {

    @IBOutlet weak var composeTextField: UITextView!
    
    var draftButton = UIBarButtonItem(title: "Drafts", style: .plain, target: nil, action: nil)
    var saveToDrafts = UIBarButtonItem(title: "Save to Drafts", style:.plain, target: nil, action: nil)
    
    let databaseInstance = DatabaseManager.sharedInstance
    
    enum ComposeUIConfiguration {
        case InitialMode
        case EmptyTweetMode
        case NotEmptyTweetMode
    }
    
    func updateComposeUI(composeUIconfig: ComposeUIConfiguration) {
        
        
        switch composeUIconfig {
        
        case .InitialMode:
            self.navigationItem.rightBarButtonItems = nil
            composeTextField.text = "Compose Tweet.."
            composeTextField.textColor = UIColor.gray
            self.navigationItem.setRightBarButton(draftButton, animated: true)
        
        case .EmptyTweetMode:
            self.navigationItem.rightBarButtonItems = nil
            composeTextField.textColor = UIColor.black
            composeTextField.text = ""
            self.navigationItem.setRightBarButton(draftButton, animated: true)
        
        case .NotEmptyTweetMode:
            composeTextField.textColor = UIColor.black
            guard composeTextField.text != ""  else {
                self.navigationItem.setRightBarButton(draftButton, animated: true)
                return
            }
            self.navigationItem.setRightBarButton(saveToDrafts, animated: true)
            
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveToDrafts.target = self
        saveToDrafts.action = #selector(saveToDraftsTapped)
        
        draftButton.target = self
        draftButton.action = #selector(draftsTapped)
        
        composeTextField.delegate = self
        
        updateComposeUI(composeUIconfig: .InitialMode)
    }

    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if composeTextField.text != "" {
            if composeTextField.text == "Compose Tweet.." {
                updateComposeUI(composeUIconfig: .EmptyTweetMode)
            } else {
                updateComposeUI(composeUIconfig: .NotEmptyTweetMode)
                }
            }
        else {
                updateComposeUI(composeUIconfig: .EmptyTweetMode)
        }

    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setupTextFieldsAccessoryView()
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        updateComposeUI(composeUIconfig: .NotEmptyTweetMode)
    }
 
    func setupTextFieldsAccessoryView() {
        guard composeTextField.inputAccessoryView == nil else {
            print("textfields accessory view already set up")
            return
        }
        let toolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolBar.backgroundColor = UIColor.darkGray
        toolBar.isTranslucent = false
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let tweetButton: UIBarButtonItem = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didPressDoneButton))
        toolBar.items = [flexsibleSpace, tweetButton]
        composeTextField.inputAccessoryView = toolBar
    }
    
    @objc func didPressDoneButton(button: UIButton) {
        composeTextField.resignFirstResponder()
        guard let tweetText = composeTextField.text,
        composeTextField.text != ""
        else {
            return
        }
        ComposeManager.shared.postTweet(statusString: tweetText,
                                        successHandler: { (response) in
            
            let alert = UIAlertController(title: "Status", message: "Success", preferredStyle: UIAlertControllerStyle.alert)
            let action =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: self.successOk)
            alert.addAction(action)
            DispatchQueue.main.async {
                self.composeTextField.text = ""
                self.present(alert, animated: true, completion: nil)
            }
        }) { (error) in
            self.displayError(error: error)
        }
    }
    func successOk(alert: UIAlertAction!){
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func draftsTapped () {
        let draftVC = storyboard?.instantiateViewController(withIdentifier: "DraftsViewController") as! DraftsViewController
        //navigationController?.pushViewController(draftVC, animated: true)
        draftVC.delegate = self
        self.present(draftVC, animated: true, completion: nil)
    }
    
   @objc func saveToDraftsTapped() {
    guard let draftTweet = composeTextField.text,
        composeTextField.text != "" else {
            return
    }
    databaseInstance.saveTweetDraft(tweetText: draftTweet)
    
    let alert = UIAlertController(title: "Save to Drafts ", message: "Success", preferredStyle: UIAlertControllerStyle.alert)
    let action =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
    self.composeTextField.text = ""
    self.navigationItem.rightBarButtonItem = nil
    self.navigationItem.rightBarButtonItem = draftButton
    
    }
    func didSelectDraft(selectedDraft draftString: String) {
        self.composeTextField.text = draftString
        self.updateComposeUI(composeUIconfig: .NotEmptyTweetMode)
        composeTextField.becomeFirstResponder()
    }
}
