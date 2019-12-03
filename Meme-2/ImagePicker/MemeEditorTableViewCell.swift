//
//  MemeEditorTableViewCell.swift
//  Meme
//
//  Created by Vinoth kumar on 26/12/17.
//  Copyright © 2017 Vinoth kumar. All rights reserved.
//

import UIKit

class MemeEditorTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    @IBOutlet weak var memeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        //memeImageView.frame = CGRect(x: 10, y: 0, width: 100, height: 100)
    }

}
