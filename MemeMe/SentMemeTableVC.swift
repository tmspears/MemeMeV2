//
//  SentMemeTableVC.swift
//  MemeMe
//
//  Created by Timothy Spears on 10/27/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import Foundation

import UIKit

class SentMemeTableVC: UIViewController {
    // MARK - Properties
    var memes: [Meme]!
    
    
    // MARK - Outlets
    
    // MARK - Lifecycle
    
    // MARK - IB Actions
    @IBAction func addMemeButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddMemeSegue", sender: self)
    }
    
    // MARK - Table Delegate
    
    
}
