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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        let sharedModel = UIApplication.shared.delegate as! AppDelegate
        memes = sharedModel.memes
        
        sentMemeCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
    // MARK - IB Actions

    @IBAction func addMemeButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddMemeSegue", sender: self)
    }
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
