//
//  UIColor.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

enum ColorName: String {
    case movieListDarkGray = "DarkGray"
    case movieListRed = "Red"
    case movieListMediumGray = "MediumGray"
    case movieListLightBeige = "LightBeige"
    case movieListDarkBlue = "DarkBlue"
    case movieListLightGray = "LightGray"
}

extension UIColor {
    
    static func createColor(color: ColorName) -> UIColor {
        return UIColor(named: color.rawValue) ?? UIColor.black
    }
}
