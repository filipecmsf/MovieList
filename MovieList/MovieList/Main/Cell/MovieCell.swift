//
//  MovieCell.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet private weak var posterImage: UIImageView! {
        didSet {
            posterImage.backgroundColor = UIColor.clear
            posterImage.contentMode = .scaleAspectFit
            posterImage.layer.borderColor = UIColor.black.cgColor
            posterImage.layer.borderWidth = 2
            posterImage.layer.cornerRadius = 5
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
    
    @IBOutlet weak var genresLabel: UILabel! {
        didSet {
            genresLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 15)
            genresLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
            genresLabel.numberOfLines = 2
        }
    }
    
    func setData(movieViewEntity: MainMovieViewEntity) {
        titleLabel.text = movieViewEntity.title
        releaseDateLabel.text = movieViewEntity.releaseDate
        genresLabel.text = movieViewEntity.genreList.joined(separator: ", ")
        
        guard let url = Bundle.getValueFromInfo(key: .imageUrl) else {
            // TODO: show error
            return
        }
        
        let urlString = String(format:"%@%@",url, movieViewEntity.posterPath)
        posterImage.af_setImage(withURL: URL(string: urlString)!)
    }
    
}
