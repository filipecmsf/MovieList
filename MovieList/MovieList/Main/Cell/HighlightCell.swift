//
//  HighlightCollectionCell.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class HighlightCell: UITableViewCell {
    
    @IBOutlet weak var highlightCollectionView: UICollectionView! {
        didSet {
            highlightCollectionView.delegate = self
            highlightCollectionView.dataSource = self
            highlightCollectionView.backgroundColor = UIColor.createColor(color: .MovieListDarkBlue)
            
            highlightCollectionView.contentInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 90)
            highlightCollectionView.register(UINib(nibName: "HighlightCollectionItemCell", bundle: .main), forCellWithReuseIdentifier: "HighlightCollectionItemCell")
        }
    }
}

extension HighlightCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightCollectionItemCell", for: indexPath) as? HighlightCollectionItemCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
