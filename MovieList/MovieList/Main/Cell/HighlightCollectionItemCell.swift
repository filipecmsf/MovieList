//
//  HighlightCollectionCell.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class HighlightCollectionItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var backgroundImage: UIImageView! {
        didSet {
            backgroundImage.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            
        }
    }
    
}
