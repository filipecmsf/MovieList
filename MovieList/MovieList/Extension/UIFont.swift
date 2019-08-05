//
//  UIFont.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

enum FontName: String {
    case movieListSourceSansProRegular = "SourceSansPro-Regular"
    case movieListSourceSansProLight = "SourceSansPro-Light"
    case movieListSourceSansProBold = "SourceSansPro-Bold"
}

extension UIFont {
    
    static func createFont(font: FontName, size: CGFloat ) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont()
    }
}
