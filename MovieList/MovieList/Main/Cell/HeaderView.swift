//
//  HeaderView.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.createFont(font: .movieListSourceSansProBold, size: 30)
            titleLabel.textColor = UIColor.createColor(color: .movieListDarkGray)
            titleLabel.text = ""
        }
    }
    @IBOutlet private weak var backgroundImage: UIImageView!
    
    func setStyleWithoutBackground() {
        backgroundImage.isHidden = true
        titleLabel.textColor = UIColor.white
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
