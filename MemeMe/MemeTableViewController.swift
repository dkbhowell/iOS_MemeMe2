//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Dustin Howell on 2/20/17.
//  Copyright © 2017 Dustin Howell. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        memes = fetchSavedMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = fetchSavedMemes()
        setBackground(forSize: view.frame.size)
        tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setBackground(forSize: size)
    }
    
    func setBackground(forSize size: CGSize) {
        // use default table background if there are memes to display
        if memes.count > 0 {
            tableView.backgroundView = nil
            tableView.separatorColor = nil
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
        tableView.backgroundView = imageView
        tableView.separatorColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
    }

    private func fetchSavedMemes() -> [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memedImage
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetailController") as! MemeDetailViewController
        detailController.meme = meme
        navigationController?.pushViewController(detailController, animated: true)
    }
}
