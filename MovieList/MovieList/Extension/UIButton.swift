//
//  UIButton.swift
//  MovieList
//
//  Created by Filipe Faria on 04/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

extension UIButton {
    func setStyle(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.createFont(font: .movieListSourceSansProRegular, size: 20)
        backgroundColor = UIColor.createColor(color: .movieListMediumGray)
        layer.borderColor = UIColor.createColor(color: .movieListLightGray).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
}
