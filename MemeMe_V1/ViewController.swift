//
//  ViewController.swift
//  MemeMe_V1
//
//  Created by Timothy Spears on 7/10/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Default Text Settings
    
    let textSettings: [String: Any] = [
        NSStrokeColorAttributeName: UIColor .black,
        NSForegroundColorAttributeName: UIColor .white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.5]
    
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
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.defaultTextAttributes = textSettings
        bottomTextField.defaultTextAttributes = textSettings
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        shareButton.isEnabled = false
    }
    
//TODO function for picking image

    // Select Image from album
    @IBAction func selectMemeImage(_ sender: Any) {
        
        let selectImageController = UIImagePickerController()
        selectImageController.sourceType = .savedPhotosAlbum
        selectImageController.delegate = self
        present(selectImageController, animated: true, completion: nil)
    }
    
    //Use camera for image
    @IBAction func useCameraForImage(_ sender: Any) {
        
        let usePhotoImageController = UIImagePickerController()
        usePhotoImageController.sourceType = .camera
        usePhotoImageController.delegate = self
        present(usePhotoImageController,animated: true, completion: nil)
    }
   
    // MARK - Image Picker Delegate
    
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
    
    // MARK - Keyboard Adjustment
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
    
    // MARK - Create Meme Image
    
    func combineMemeElementsAsImage() -> UIImage {
        
        //error handling
        print("combineMemeElementsAsImage function started")
        
        // Hide navigation and tool bars
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navigation and tool bars again
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memeImage
    }
    
    // MARK: - Save Meme
    
    //Does not seem to be needed for project but part of Udacity instructions...
    func saveMeme() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, savedMeme: combineMemeElementsAsImage())
    }
    
    
    // MARK: - Share Meme
    
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
    
    // MARK: - Reset Application
    
    @IBAction func cancelButtonSelected(_ sender: UIBarButtonItem) {
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeImageView.image = nil
        shareButton.isEnabled = false
    }
    

}

