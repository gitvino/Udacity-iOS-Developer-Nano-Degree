//
//  MemeEditorViewController.swift
//  ImagePicker
//
//  Created by Vinoth kumar on 24/10/17.
//  Copyright © 2017 Vinoth kumar. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController{
    
    
    @IBOutlet weak var memeImageOutlet: UIImageView!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    
    //Bool to represent UI state
    var isImageLoaded = false
    
    //Meme Text Attributes
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 50)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        //Enable Camera button only if camera is available
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Configure the UI
        configureUI(isImageLoaded: isImageLoaded)
        
        //Subcribe to Keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
   
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        //Unsubcribe from Keyboard notifications before View disappears
        self.unsubscribeFromKeyboardNotifications()
    }
    

    @IBAction func shareButton(_ sender: Any) {
        
        //hide the toolbar buttons before creating the image
        displayToolbar(true)
       
        //generate meme Image
        let memeImage = generateMemeImage()
        
        //show the toolbar buttons after creating the image
        displayToolbar(false)
        
        //activity controller to share
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        //call save in activity view controller's completion handler
        activityController.completionWithItemsHandler = { (
            UIActivityType:UIActivityType?,
            completed: Bool,
            returnedItems: [Any]?,
            error: Error?) in
            if completed {
                self.save(memeImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        pickImage(fromSource: .camera)
    }
    
    
    @IBAction func albumButtonPressed(_ sender: Any) {
        pickImage(fromSource: .photoLibrary)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)        
    }
    
    func displayToolbar(_ status: Bool){
        topToolBar.isHidden = status
        bottomToolbar.isHidden = status
    }
    
    func generateMemeImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memeImage
    }
    
    
    func configureUI(isImageLoaded configuration: Bool) {
        configureText(textField: topText, withText: "TOP", enabled: configuration)
        configureText(textField: bottomText, withText: "BOTTOM", enabled: configuration)
        shareButtonItem.isEnabled = configuration
    }
    
    func configureText(textField: UITextField, withText text:String, enabled isEnabled: Bool){
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.isEnabled = isEnabled
        textField.textAlignment = .center
    }
    
    func save(_ memeImage: UIImage) {
        
        let meme = Meme(topText: topText.text!,
                        bottomText: bottomText.text!,
                        originalImage: memeImageOutlet.image!,
                        memedImage: memeImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
   
    
    //Subscribe to Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    //Unsubscribe to Keyboard Notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillShow)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillHide)        
    }
    
   
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0 
    }
    
    func getKeyboardHeight(_ notificaiton: Notification) -> CGFloat {
        let userInfo = notificaiton.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func pickImage (fromSource source: UIImagePickerControllerSourceType) {
        let cameraViewController = UIImagePickerController()
        cameraViewController.sourceType = source
        cameraViewController.delegate = self
        present(cameraViewController, animated: true, completion: nil)

    }
}





extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageOutlet.contentMode = .scaleAspectFit
            memeImageOutlet.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
        isImageLoaded = true
    }
}
extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}


