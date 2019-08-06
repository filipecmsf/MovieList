//
//  String.swift
//  MovieList
//
//  Created by Filipe Faria on 04/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Foundation

extension String {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        
        dateFormatter.dateFormat = "MMM - dd - yyyy"
        return dateFormatter.string(from: date)
    }
}
