//
//  Bundle.swift
//  MovieList
//
//  Created by Filipe Faria on 03/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

enum ConfigKey: String {
    case baseUrl = "base_url"
    case imageUrl = "image_url"
    case apiKey = "api_key"
}

extension Bundle {
    
    static func getValueFromInfo(key: ConfigKey) -> String? {
        return Bundle.main.infoDictionary?[key.rawValue] as? String
    }
}
