//
//  StudentCellTableViewCell.swift
//  On The Map
//
//  Created by Vinoth kumar on 29/3/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit

@IBDesignable
class StudentCellTableViewCell: UITableViewCell {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var mediaURL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
