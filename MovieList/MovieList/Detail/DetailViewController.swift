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
    @IBOutlet weak var posterBackgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var rateView: UIView! {
        didSet {
            rateView.layer.cornerRadius = rateView.frame.size.height / 2
            rateView.backgroundColor = UIColor.createColor(color: .MovieListRed)
        }
    }
    @IBOutlet weak var voteAverageTitleLabel: UILabel! {
        didSet {
            voteAverageTitleLabel.textAlignment = .center
            voteAverageTitleLabel.textColor = UIColor.white
            voteAverageTitleLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 15)
        }
    }
    @IBOutlet weak var voteAverageLabel: UILabel! {
        didSet {
            voteAverageLabel.textAlignment = .center
            voteAverageLabel.contentMode = .topLeft
            voteAverageLabel.textColor = UIColor.white
            voteAverageLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 50)
        }
    }
    
    @IBOutlet weak var nameTitleLabel: UILabel! {
        didSet {
            nameTitleLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 20)
            nameTitleLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 20)
            titleLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var genreTitleLabel: UILabel! {
        didSet {
            genreTitleLabel.contentMode = .top
            genreTitleLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 20)
            genreTitleLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
        }
    }
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            genreLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 20)
            genreLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
            genreLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var releaseTitleLabel: UILabel! {
        didSet {
            releaseTitleLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 20)
            releaseTitleLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
        }
    }
    @IBOutlet weak var releaseLabel: UILabel! {
        didSet {
            releaseLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 20)
            releaseLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
            releaseLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var overviewTitleLabel: UILabel! {
        didSet {
            overviewTitleLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
            overviewTitleLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 20)
        }
    }
    @IBOutlet weak var overviewLabel: UILabel! {
        didSet {
            overviewLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 20)
            overviewLabel.textColor = UIColor.createColor(color: .MovieListDarkGray)
            overviewLabel.numberOfLines = 0
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
    
    // MARK: - public methods
    
    
    
    // MARK: - private methods
    
    private func setTitle() {
        title = viewModel?.getTitle()
        titleLabel.text = viewModel?.getTitle()
    }
    
    private func setOverview() {
        overviewLabel.text = viewModel?.getOverview()
    }
    
    private func setGenre() {
        genreLabel.text = viewModel?.getGenders()
    }
    
    private func setReleaseDate() {
        releaseLabel.text = viewModel?.getReleaseDate()
    }
    
    private func setVoteAverage() {
        voteAverageLabel.text = viewModel?.getVoteAverage()
    }
    
    private func setPoster() {
        guard let url = getPosterUrl() else {
            return
        }
        
        posterBackgroundImage.af_setImage(withURL: url)
        posterImage.af_setImage(withURL: url)
    }
    
    private func getPosterUrl() -> URL? {
        guard let url = Bundle.getValueFromInfo(key: .imageUrl),
            let posterPath = viewModel?.getPosterPath() else {
                // TODO: show error
                return nil
        }
        
        return URL(string:String(format:"%@%@",url, posterPath))
    }
}
