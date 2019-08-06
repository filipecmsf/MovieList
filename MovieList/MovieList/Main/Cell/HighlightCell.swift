//
//  HighlightCollectionCell.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class HighlightCell: UITableViewCell {
    
    var selectedMovieId: ((Int) -> Void)?
    private var hightlightMovieList: [MainMovieViewEntity] = []
    
    @IBOutlet private weak var highlightCollectionView: UICollectionView! {
        didSet {
            highlightCollectionView.delegate = self
            highlightCollectionView.dataSource = self
            highlightCollectionView.backgroundColor = UIColor.createColor(color: .movieListDarkBlue)
            
            highlightCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            highlightCollectionView.register(UINib(nibName: "HighlightCollectionItemCell", bundle: .main), forCellWithReuseIdentifier: "HighlightCollectionItemCell")
        }
    }
    
    func setData(list: [MainMovieViewEntity]) {
        hightlightMovieList = list
        highlightCollectionView.reloadData()
    }
}

extension HighlightCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hightlightMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightCollectionItemCell", for: indexPath) as? HighlightCollectionItemCell {
            
            cell.setData(mainMovieViewEntity: hightlightMovieList[indexPath.row])
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovieId?(hightlightMovieList[indexPath.row].id)
    }
}
