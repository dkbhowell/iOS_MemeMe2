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
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Properties
    var memes: [Meme] = [Meme]()
    let layoutPadding: CGFloat = 5.0
    let minItemSize: CGFloat = 125
    let maxItemsPerRow: CGFloat = 10
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = fetchSavedMemes()
        setLayout(forSize: self.view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CollectionView ViewWillAppear")
        memes = fetchSavedMemes()
        
        // Add Custom Background if there are no memes to display
        setBackground(forSize: view.frame.size)
        
        // refresh data
        collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setLayout(forSize: size)
        setBackground(forSize: size)
    }
    
    // MARK: CollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let memeForCell = memes[indexPath.row]
        cell.memeImage.image = memeForCell.memedImage
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeme = memes[indexPath.row]
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetailController") as! MemeDetailViewController
        detailController.meme = selectedMeme
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    // MARK: Helper Functions
    
    private func fetchSavedMemes() -> [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    func setBackground(forSize size: CGSize) {
        // use default collection background if there are memes to display
        if memes.count > 0 {
            collectionView?.backgroundView = nil
            return
        }
        // Set 'no memes' image if there are no memes to display
        var image: UIImage
        if size.width > size.height {
            image = UIImage(named: "NoSavedMemes_horizontal")!
        } else {
            image = UIImage(named: "NoSavedMemes_vertical")!
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        collectionView?.backgroundView = imageView
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
}
