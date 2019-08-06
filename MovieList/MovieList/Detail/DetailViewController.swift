//
//  DetailViewController.swift
//  MovieList
//
//  Created by Filipe Faria on 03/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - properties
    @IBOutlet private weak var posterBackgroundImage: UIImageView!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var voteAverageView: UIView! {
        didSet {
            voteAverageView.layer.cornerRadius = voteAverageView.frame.size.height / 2
            voteAverageView.backgroundColor = UIColor.createColor(color: .movieListRed)
        }
    }
    @IBOutlet private weak var voteAverageTitleLabel: UILabel! {
        didSet {
            voteAverageTitleLabel.textAlignment = .center
            voteAverageTitleLabel.textColor = UIColor.white
            voteAverageTitleLabel.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 15)
            voteAverageTitleLabel.text = NSLocalizedString("detail.rate_title", comment: "")
            
        }
    }
    @IBOutlet private weak var voteAverageLabel: UILabel! {
        didSet {
            voteAverageLabel.textAlignment = .center
            voteAverageLabel.contentMode = .topLeft
            voteAverageLabel.textColor = UIColor.white
            voteAverageLabel.font = UIFont.createFont(font: .movieListSourceSansProBold, size: 50)
            voteAverageLabel.text = NSLocalizedString("empty_text", comment: "")
        }
    }
    @IBOutlet private weak var titleTitleLabel: UILabel! {
        didSet {
            titleTitleLabel.contentMode = .top
            titleTitleLabel.font = UIFont.createFont(font: .movieListSourceSansProBold, size: 15)
            titleTitleLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            titleTitleLabel.text = NSLocalizedString("detail.title_title", comment: "")
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 15)
            titleLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            titleLabel.numberOfLines = 0
            titleLabel.text = NSLocalizedString("empty_text", comment: "")
        }
    }
    @IBOutlet private weak var genreTitleLabel: UILabel! {
        didSet {
            genreTitleLabel.contentMode = .top
            genreTitleLabel.font = UIFont.createFont(font: .movieListSourceSansProBold, size: 15)
            genreTitleLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            genreTitleLabel.text = NSLocalizedString("detail.genre_title", comment: "")
        }
    }
    @IBOutlet private weak var genreLabel: UILabel! {
        didSet {
            genreLabel.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 15)
            genreLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            genreLabel.numberOfLines = 0
            genreLabel.text = NSLocalizedString("empty_text", comment: "")
        }
    }
    @IBOutlet private weak var releaseTitleLabel: UILabel! {
        didSet {
            releaseTitleLabel.font = UIFont.createFont(font: .movieListSourceSansProBold, size: 15)
            releaseTitleLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            releaseTitleLabel.text = NSLocalizedString("detail.release_date_title", comment: "")
            releaseTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet private weak var releaseLabel: UILabel! {
        didSet {
            releaseLabel.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 15)
            releaseLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            releaseLabel.numberOfLines = 0
            releaseLabel.text = NSLocalizedString("empty_text", comment: "")
        }
    }
    @IBOutlet private weak var overviewTitleLabel: UILabel! {
        didSet {
            overviewTitleLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            overviewTitleLabel.font = UIFont.createFont(font: .movieListSourceSansProBold, size: 15)
            overviewTitleLabel.text = NSLocalizedString("detail.overview_title", comment: "")
        }
    }
    @IBOutlet private weak var overviewLabel: UILabel! {
        didSet {
            overviewLabel.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 15)
            overviewLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            overviewLabel.numberOfLines = 0
            overviewLabel.text = NSLocalizedString("empty_text", comment: "")
        }
    }
    
    private var viewModel: DetailViewModel?
    
    // MARK: - setup methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPoster()
        setTitle()
        setOverview()
        setGenre()
        setReleaseDate()
        setVoteAverage()
        
    }
    
    func setViewEntity(detailViewEntity: DetailViewEntity) {
        viewModel = DetailViewModel(detailViewEntity: detailViewEntity)
    }
    
    // MARK: - private methods
    
    private func setTitle() {
        titleLabel.text = viewModel?.getTitle()
    }
    
    private func setVoteAverage() {
        if let text = viewModel?.getVoteAverage(), text != "0.0" {
            voteAverageLabel.text = text
        }
    }
    
    private func setOverview() {
        if let text = viewModel?.getOverview(), !text.isEmpty {
            overviewLabel.text = text
        }
    }
    
    private func setGenre() {
        if let text = viewModel?.getGenders(), !text.isEmpty {
            genreLabel.text = text
        }
    }
    
    private func setReleaseDate() {
        if let text = viewModel?.getReleaseDate(), !text.isEmpty {
            releaseLabel.text = text
        }
    }
    
    private func setPoster() {
        
        let placeholderImage = UIImage(named: "movie_placeholder")
        
        guard let url = getPosterUrl() else {
            posterBackgroundImage.image = placeholderImage
            posterImage.image = placeholderImage
            return
        }
        
        posterBackgroundImage.af_setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true)
        posterImage.af_setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: true)
    }
    
    private func getPosterUrl() -> URL? {
        guard let url = Bundle.getValueFromInfo(key: .imageUrl),
            let posterPath = viewModel?.getPosterPath() else {
                return nil
        }
        
        return URL(string: String(format: "%@%@", url, posterPath))
    }
}
