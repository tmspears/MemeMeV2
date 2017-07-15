//
//  ViewController.swift
//  MemeMe_V1
//
//  Created by Timothy Spears on 7/10/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // IB Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    // Default Text Settings
    let textSettings: [String: Any] = [
        NSStrokeColorAttributeName: UIColor .black,
        NSForegroundColorAttributeName: UIColor .white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2.0]
    
    // Struct to hold Meme
    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let savedMeme: UIImage
    }
    
    // MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.defaultTextAttributes = textSettings
        bottomTextField.defaultTextAttributes = textSettings
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }


    // UI Actions
    @IBAction func selectMemeImage(_ sender: Any) {
        
        let selectImageController = UIImagePickerController()
        selectImageController.sourceType = .savedPhotosAlbum
        selectImageController.delegate = self
        present(selectImageController, animated: true, completion: nil)
    }
    
    @IBAction func useCameraForImage(_ sender: Any) {
        
        let usePhotoImageController = UIImagePickerController()
        usePhotoImageController.sourceType = .camera
        usePhotoImageController.delegate = self
        present(usePhotoImageController,animated: true, completion: nil)
    }

    // Image Picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let meme = textField.text {
            if meme == "TOP" || meme == "BOTTOM" {
                textField.text = ""
            }
        }
        
        // subscribe to notification for keyboard dismissal
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == topTextField {
            if textField.text == "" {
                textField.text = "TOP"
            }
        }
        
        if textField == bottomTextField {
            if textField.text == "" {
                textField.text = "BOTTOM"
            }
        }
        
        textField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
        return true
    }
    
    // Adjust Image Position With Keyboard
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        // implementation based upon Udacity forum post:
        // https://discussions.udacity.com/t/better-way-to-shift-the-view-for-keyboardwillshow-and-keyboardwillhide/36558
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    // Store Meme Object
    
    func createMemeImage() -> UIImage {
        
        // Hide navigation and tool bars
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeCreated:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navigation and tool bars again
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memeCreated
    }
    
    func tempSaveMeme() {
    
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, savedMeme: createMemeImage())
    }
    
    
}

