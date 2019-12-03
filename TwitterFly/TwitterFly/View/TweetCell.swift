//
//  TweetCell.swift
//  TwitterFly
//
//  Created by Vinoth on 26/7/18.
//  Copyright © 2018 Vinoth. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var tweetTextViewHeightConstraint: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // tweetLabel.sizeToFit()
        tweetTextView.isScrollEnabled = false
     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
