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

    func collectionLayOutDimensions(rows: Int, columns: Int, spacing: CGFloat) {
        // using intended number of rows and columns, function sets collection flow layout
        
        let dimensionWidth = (view.frame.size.width - (CGFloat(rows - 1) * spacing)) / CGFloat(rows)
        let dimensionHeight = (view.frame.size.height - (CGFloat(columns - 1) * spacing)) / CGFloat(columns)
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if view.frame.size.width < view.frame.size.height {
            // Collection layout in portrait mode
            collectionLayOutDimensions(rows: 3, columns: 4, spacing: 2.0)
        } else {
            //Collection layout in landscape
            collectionLayOutDimensions(rows: 5, columns: 2, spacing: 2.0)
        }

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
