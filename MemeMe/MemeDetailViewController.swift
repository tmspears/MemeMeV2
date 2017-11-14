//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Timothy Spears on 11/14/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    var memeDetail: Meme!
    
    // MARK: Outlets
    @IBOutlet weak var memeImageView:UIImageView!
    
    // MARK: Life Cycle
    
    override func   viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeImageView!.image = memeDetail.savedMeme
    }
}
