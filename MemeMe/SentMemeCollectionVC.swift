//
//  SentMemeCollectionVC.swift
//  MemeMe
//
//  Created by Timothy Spears on 12/13/17.
//  Copyright © 2017 Timothy Spears. All rights reserved.
//

import Foundation

import UIKit

class SentMemeCollectionVC: UICollectionViewController {
    
    // MARK - Properties
    var memes: [Meme]!
    
    // MARK - Outlets
    @IBOutlet weak var sentMemeCollectionView: UICollectionView!
    
    // MARK - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        let sharedModel = UIApplication.shared.delegate as! AppDelegate
        memes = sharedModel.memes
        
        sentMemeCollectionView.reloadData()
    }
    
    // MARK - IB Actions

    
    
    //MARK - Collection Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
  
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeColectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.cellImage?.image = meme.savedMeme
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memeDetail = self.self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
