//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Dustin Howell on 2/22/17.
//  Copyright © 2017 Dustin Howell. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
