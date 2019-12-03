//
//  photoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Vinoth kumar on 6/5/18.
//  Copyright © 2018 Vinoth kumar. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedTick: UIImageView!
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected
            {
                
                self.selectedTick.isHidden = false
            }
            else
            {
                
                self.selectedTick.isHidden = true
            }
    }
    }
    
}
