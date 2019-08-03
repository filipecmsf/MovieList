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
            backgroundImage.backgroundColor = UIColor.clear
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.layer.borderColor = UIColor.createColor(color: .MovieListLightBeige).cgColor
            backgroundImage.layer.borderWidth = 2
            backgroundImage.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 15)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 1
        }
    }
    
    func setData(title: String, image: String) {
        titleLabel.text = title
        
        guard let url = Bundle.getValueFromInfo(key: .imageUrl) else {
            // TODO: show error
            return
        }
        
        let urlString = String(format:"%@%@",url, image)
        backgroundImage.af_setImage(withURL: URL(string: urlString)!)
    }
    
}
