//
//  TrendCell.swift
//  TwitterFly
//
//  Created by Vinoth on 17/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit

class TrendCell: UITableViewCell {

    @IBOutlet weak var countCell: UILabel!
    @IBOutlet weak var trendTopic: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
