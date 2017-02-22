//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Dustin Howell on 2/20/17.
//  Copyright © 2017 Dustin Howell. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCollectionCell"

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] = [Meme]()
    
    let layoutPadding: CGFloat = 5.0
    let minItemSize: CGFloat = 150
    let maxItemsPerRow: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memes = fetchSavedMemes()
        
        setLayout(forSize: self.view.frame.size)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CollectionView ViewWillAppear")
        memes = fetchSavedMemes()
        
        // Add Custom Background if there are no memes to display
        if memes.count == 0 {
            let image = UIImage(named: "NoSavedMemes")
            let imageView = UIImageView(image: image)
            collectionView?.backgroundView = imageView
        } else {
            // restore background default?
            collectionView?.backgroundView = nil
        }
        
        // refresh data
        collectionView?.reloadData()
    }

    private func fetchSavedMemes() -> [Meme] {
        
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setLayout(forSize: size)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        
        let memeForCell = memes[indexPath.row]
    
        // Configure the cell
        cell.memeImage.image = memeForCell.memedImage
    
        return cell
    }
    
    func setLayout(forSize size: CGSize) {
        let itemSize = getItemDimensions(forContainerSize: size, spacing: layoutPadding, minDimensSize: minItemSize)
        flowLayout.minimumInteritemSpacing = layoutPadding
        flowLayout.minimumLineSpacing = layoutPadding
        flowLayout.itemSize = itemSize
    }
    
    func getItemDimensions(forContainerSize size: CGSize, spacing: CGFloat, minDimensSize: CGFloat) -> CGSize {
        var itemsPerRow: CGFloat = CGFloat(maxItemsPerRow)
        let containerWidth = size.width
        
        while (containerWidth - (itemsPerRow - 1) * spacing) / itemsPerRow < minDimensSize {
            itemsPerRow -= 1
        }
        
        let dimens = (containerWidth - (itemsPerRow - 1) * spacing) / itemsPerRow
        return CGSize(width: dimens, height: dimens)
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeme = memes[indexPath.row]
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetailController") as! MemeDetailViewController
        detailController.meme = selectedMeme
        
        navigationController?.pushViewController(detailController, animated: true)
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
