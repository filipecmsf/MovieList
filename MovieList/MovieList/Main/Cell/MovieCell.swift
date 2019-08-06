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
            titleLabel.font = UIFont.createFont(font: .movieListSourceSansProBold, size: 20)
            titleLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
        }
    }
    @IBOutlet private weak var releaseDateLabel: UILabel! {
        didSet {
            releaseDateLabel.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 15)
            releaseDateLabel.textColor = UIColor.createColor(color: .movieListMediumGray)
        }
    }
    
    @IBOutlet private weak var genresLabel: UILabel! {
        didSet {
            genresLabel.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 15)
            genresLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            genresLabel.numberOfLines = 2
        }
    }
    
    func setData(movieViewEntity: MainMovieViewEntity) {
        titleLabel.text = movieViewEntity.title
        releaseDateLabel.text = movieViewEntity.releaseDate
        genresLabel.text = movieViewEntity.genreList.joined(separator: ", ")
        
        let placeholderImage = UIImage(named: "movie_placeholder")
        guard let baseUrl = Bundle.getValueFromInfo(key: .imageUrl),
            let posterPath = movieViewEntity.posterPath,
            let url = URL(string: String(format: "%@%@", baseUrl, posterPath)) else {
            posterImage.image = placeholderImage
            return
        }
        
        posterImage.af_setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true)
    }
    
    func setData(searchMovieViewEntity: SearchMovieViewEntity) {
        titleLabel.text = searchMovieViewEntity.title
        releaseDateLabel.text = searchMovieViewEntity.releaseDate
        genresLabel.text = searchMovieViewEntity.genreList.joined(separator: ", ")
        
        let placeholderImage = UIImage(named: "movie_placeholder")
        guard let baseUrl = Bundle.getValueFromInfo(key: .imageUrl),
            let posterPath = searchMovieViewEntity.posterPath,
            let url = URL(string: String(format: "%@%@", baseUrl, posterPath)) else {
                posterImage.image = placeholderImage
                return
        }
        
        posterImage.af_setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true)
    }
}
