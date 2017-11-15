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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.cellImage?.image = meme.originalImage
        cell.cellTopLabel?.text = meme.topText
        cell.cellBottomLabel?.text = meme.bottomText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memeDetail = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
