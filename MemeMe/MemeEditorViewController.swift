//
//  MemeEditorViewController.swift
//  MemeMe_V1
//
//  Created by Timothy Spears on 7/10/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Default Text Settings
    
    let textSettings: [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor .black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor .white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue : -3.5]
    
    // MARK: - Lifecycle methods
    
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
        
        
        
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        
        shareButton.isEnabled = false
    }

    // MARK - Image Picker Delegate
    
    func pickImage(sourceType: UIImagePickerControllerSourceType) {
        let imageController = UIImagePickerController()
        imageController.sourceType = sourceType
        imageController.delegate = self
        present(imageController,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = pickedImage
            shareButton.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text Field Delegate
    
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
                prepareTextField(textField: topTextField, defaultText: "TOP")
            }
        }
        
        if textField == bottomTextField {
            if textField.text == "" {
                prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
            }
        }
        
        textField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
        return true
    }
    
    // sets intial settings for text fields
    func prepareTextField(textField: UITextField, defaultText: String) {
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        textField.defaultTextAttributes = textSettings
        textField.text = defaultText
        textField.textAlignment = .center
    }
    
    // MARK - Keyboard Adjustment
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        // implementation based upon Udacity forum post:
        // https://discussions.udacity.com/t/better-way-to-shift-the-view-for-keyboardwillshow-and-keyboardwillhide/36558
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
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
    
    // MARK - Create Meme Image
    
    func combineMemeElementsAsImage() -> UIImage {
        
        // Hide navigation and tool bars
        hideBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navigation and tool bars again
        hideBars(false)
        
        return memeImage
    }
    
    func hideBars(_ barBool: Bool) {
        navBar.isHidden = barBool
        toolBar.isHidden = barBool
    }
    
    // MARK: - Save Meme
    
    func saveMeme() {
        // create meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, savedMeme: combineMemeElementsAsImage())
        // add meme to meme array in app delegate
        let object = UIApplication.shared.delegate
        let sharedModel = object as! AppDelegate
        sharedModel.memes.append(meme)
    }
    
    // MARK: - IB Actions

    // Select Image from album
    @IBAction func selectMemeImage(_ sender: Any) {
        
        pickImage(sourceType: .savedPhotosAlbum)
    }
    
    // Use camera for image
    @IBAction func useCameraForImage(_ sender: Any) {
        
        pickImage(sourceType: .camera)
    }
    
    // Share Meme
    @IBAction func shareButtonSelected(_ sender: UIBarButtonItem) {
        
        let memeToShare = combineMemeElementsAsImage()
        
        let activityVC = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [
            UIActivityType.copyToPasteboard,
            UIActivityType.airDrop,
            UIActivityType.addToReadingList,
            UIActivityType.assignToContact,
            UIActivityType.openInIBooks,
            UIActivityType.print]
        
        self.present(activityVC, animated: true,completion: nil)
        
        activityVC.completionWithItemsHandler = {
            activityType, completed, returenedItems, activityError in
            if completed {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    // Reset Application
    @IBAction func cancelButtonSelected(_ sender: UIBarButtonItem) {
        
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        memeImageView.image = nil
        shareButton.isEnabled = false
        
        dismiss(animated: true, completion: nil)
    }
    

}

