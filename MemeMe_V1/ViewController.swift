//
//  ViewController.swift
//  MemeMe_V1
//
//  Created by Timothy Spears on 7/10/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: variable and constants
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    // MARK: UI actions
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

    // MARK: Image Picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

