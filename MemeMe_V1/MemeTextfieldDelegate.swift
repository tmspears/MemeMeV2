//
//  MemeTextfieldDelegate.swift
//  MemeMe_V1
//
//  Created by Timothy Spears on 7/19/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import Foundation

import UIKit

// MARK: - MemeTextfieldDelegate

class MemeTextfieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: - Default Text Settings
    
    let textSettings: [String: Any] = [
        NSStrokeColorAttributeName: UIColor .black,
        NSForegroundColorAttributeName: UIColor .white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.5]
    
    // MARK: - Text Field Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // clear textfield if no prior text changes
        if let memeText = textField.text {
            if memeText == "TOP" || memeText == "BOTTOM" {
                textField.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        
        textField.defaultTextAttributes = textSettings
        
        textField.text = defaultText
        textField.textAlignment = .center
    }
    
}
