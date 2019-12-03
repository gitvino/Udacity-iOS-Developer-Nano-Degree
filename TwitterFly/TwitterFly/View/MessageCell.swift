//
//  MessageCell.swift
//  TwitterFly
//
//  Created by Vinoth on 20/8/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var senderUserName: UILabel!
    @IBOutlet weak var messageCreatedDate: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var senderScreenName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
