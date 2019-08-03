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
    @IBOutlet weak var coverBackgroundImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var rateView: UIView! {
        didSet {
            rateView.layer.cornerRadius = rateView.frame.size.height / 2
            rateView.backgroundColor = UIColor.createColor(color: .MovieListRed)
        }
    }
    @IBOutlet weak var rateTitleLabel: UILabel! {
        didSet {
            rateTitleLabel.textAlignment = .center
            rateTitleLabel.textColor = UIColor.white
            rateTitleLabel.font = UIFont.createFont(font: .MovieListSourceSansProRegular, size: 15)
            rateTitleLabel.text = "Rate"
        }
    }
    @IBOutlet weak var rateLabel: UILabel! {
        didSet {
            rateLabel.textAlignment = .center
            rateLabel.contentMode = .top
            rateLabel.textColor = UIColor.white
            rateLabel.font = UIFont.createFont(font: .MovieListSourceSansProBold, size: 50)
            rateLabel.text = "8.8"
        }
    }
    
    // MARK: - setup methods
    override func viewWillAppear(_ animated: Bool) {
        configNavigation()
        title = "rei leao"
    }
    
    private func configNavigation() {
        navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - public methods
    
    // MARK: - private methods
    
}
