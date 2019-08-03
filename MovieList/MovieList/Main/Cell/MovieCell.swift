//
//  MovieCell.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet private weak var coverImage: UIImageView! {
        didSet {
            coverImage.backgroundColor = UIColor.clear
            coverImage.contentMode = .scaleAspectFit
            coverImage.layer.borderColor = UIColor.black.cgColor
            coverImage.layer.borderWidth = 2
            coverImage.layer.cornerRadius = 5
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 20)
            titleLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
        }
    }
    @IBOutlet private weak var releaseDateLabel: UILabel! {
        didSet {
            releaseDateLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 15)
            releaseDateLabel.textColor = UIColor.createColor(color: .MovieListMediumGray)
        }
    }
    
    func setData(title: String, release: String, image: String?) {
        titleLabel.text = title
        releaseDateLabel.text = release
        
        guard let imagePath = image else {
            return
        }
        
        guard let url = Bundle.getValueFromInfo(key: .imageUrl) else {
            // TODO: show error
            return
        }
        
        let urlString = String(format:"%@%@",url, imagePath)
        coverImage.af_setImage(withURL: URL(string: urlString)!)
    }
    
}
