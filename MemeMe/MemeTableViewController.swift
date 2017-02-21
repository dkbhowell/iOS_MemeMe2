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
        print("TableView viewDidLoad")
        super.viewDidLoad()
        
        memes = fetchSavedMemes()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("TableView viewWillAppear")
        memes = fetchSavedMemes()
        
        if memes.count == 0 {
            // Set background of Table View to stock image and hide separators
            print("Saved Meme Count is 0")
            let image = UIImage(named: "NoSavedMemes")
            let imageView = UIImageView(image: image)
            tableView.backgroundView = imageView
            tableView.separatorColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        } else {
            // Restore Defaults??
            tableView.backgroundView = nil
            tableView.separatorColor = nil
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath)

        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText

        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "memeDetailController") as! MemeDetailViewController
        detailController.meme = meme
        navigationController?.pushViewController(detailController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
