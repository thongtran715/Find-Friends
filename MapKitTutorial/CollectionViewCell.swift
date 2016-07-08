//
//  CollectionViewCell.swift
//  
//
//  Created by Thong Tran on 7/1/16.
//
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20.0
        self.clipsToBounds = true
    }
    
}
