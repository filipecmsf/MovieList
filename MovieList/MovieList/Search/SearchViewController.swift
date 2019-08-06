//
//  SearchViewController.swift
//  MovieList
//
//  Created by Filipe Faria on 05/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    var viewModel: SeachViewModel?
    var timer: Timer?
    private let searchMovieDetailViewSegueIdentifier = "searchMovieDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieCell", bundle: .main), forCellReuseIdentifier: "MovieCell")
        implementViewModel()
    }
    
    func setGenres(genres: [Genre]) {
        viewModel = SeachViewModel(interactor: SearchInteractor(repository: MainRepository()))
    }
    
    @objc func searchMovies(text: String) {
        viewModel?.getMovies(text: text)
    }
    
    // MARK: - private methods
    private func implementViewModel() {
        viewModel?.reloadTableView = {[weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel?.showError = {[weak self] msg in
            self?.showError(msg: msg)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == searchMovieDetailViewSegueIdentifier,
            let detailViewEntity = sender as? DetailViewEntity,
            let detailViewController = segue.destination as? DetailViewController {
            detailViewController.setViewEntity(detailViewEntity: detailViewEntity)
        }
    }
    
    private func showError(msg: String) {
        let alert = UIAlertController(title: NSLocalizedString("alert.title", comment: ""), message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.button", comment: ""), style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func openMovieDetails(id: Int) {
        
        if let detailViewEntity = viewModel?.getDetailViewEntity(id: id) {
            performSegue(withIdentifier: searchMovieDetailViewSegueIdentifier, sender: detailViewEntity)
        }
    }
    
    private func loadMoreMovies() {
        viewModel?.getMoreMovies()
    }
    
    // MARK: - TABLEVIEW METHODS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getListCount() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        checkHasMoreCells(row: row)
        if let cell = createMovieCell(row: row) {
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("search.search_placeholder", comment: "")
        searchBar.delegate = self
        searchBar.text = viewModel?.getSearchText()
        
        return searchBar
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let id = viewModel?.getMovieBy(index: indexPath.row)?.id {
            openMovieDetails(id: id)
        }
    }
    
    // MARK: - AUXILIAR METHODS
    private func createMovieCell(row: Int) -> MovieCell? {
        
        if let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell,
            let movie = viewModel?.getMovieBy(index: row) {
            
            cell.setData(searchMovieViewEntity: movie)
            return cell
        }
        return nil
    }
    
    private func checkHasMoreCells(row: Int) {
        if let totalItems = viewModel?.getListCount(),
            row == totalItems - 1 {
            loadMoreMovies()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if timer?.isValid ?? false {
            timer?.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {timer in
            if timer.isValid {
                self.searchMovies(text: searchText)
            }
        }
    }
}
