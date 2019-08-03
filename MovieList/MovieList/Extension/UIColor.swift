//
//  UIColor.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

enum ColorName: String {
    case MovieListDarkGray = "DarkGray"
    case MovieListRed = "Red"
    case MovieListMediumGray = "MediumGray"
    case MovieListLightBeige = "LightBeige"
    case MovieListDarkBlue = "DarkBlue"
}

extension UIColor {
    
    static func createColor(color: ColorName) -> UIColor {
        return UIColor(named: color.rawValue) ?? UIColor.black
    }
}
