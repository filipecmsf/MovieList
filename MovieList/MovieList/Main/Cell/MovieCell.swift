//
//  MovieCell.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet private weak var coverImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 25)
            titleLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
        }
    }
    @IBOutlet private weak var releaseDateLabel: UILabel! {
        didSet {
            releaseDateLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 15)
            releaseDateLabel.textColor = UIColor.createColor(color: .MovieListMediumGray)
        }
    }
    
}
