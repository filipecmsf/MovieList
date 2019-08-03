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
    
    func setData(title: String, image: String) {
        
        titleLabel.text = title
        
        let urlString = String(format:"https://image.tmdb.org/t/p/w500%@", image)
        backgroundImage.af_setImage(withURL: URL(string: urlString)!)
    }
    
}
