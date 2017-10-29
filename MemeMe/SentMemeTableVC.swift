//
//  SentMemeTableVC.swift
//  MemeMe
//
//  Created by Timothy Spears on 10/27/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import Foundation

import UIKit

class SentMemeTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK - Properties
    var memes: [Meme]!
    
    
    // MARK - Outlets
    @IBOutlet weak var sentMemeTableView: UITableView!
    
    // MARK - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        let sharedModel = UIApplication.shared.delegate as! AppDelegate
        memes = sharedModel.memes
        
        sentMemeTableView.reloadData()
    }
    
    // MARK - IB Actions
    @IBAction func addMemeButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddMemeSegue", sender: self)
    }
    
    // MARK - Table Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
        
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.imageView?.image = meme.savedMeme
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        
        return cell
    }
}
