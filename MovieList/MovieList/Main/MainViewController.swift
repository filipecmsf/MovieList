//
//  ViewController.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//



import UIKit
import Alamofire

class MainViewController: UIViewController {
    
// MARK: - properties
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            tableView.register(UINib(nibName: "HighlightCell", bundle: .main), forCellReuseIdentifier: "HighlightCell")
            tableView.register(UINib(nibName: "MovieCell", bundle: .main), forCellReuseIdentifier: "MovieCell")
        }
    }
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var retryButton: UIButton! {
        didSet {
            retryButton.setStyle(title: NSLocalizedString("error.retry", comment: ""))
            retryButton.isHidden = true
        }
    }
    
    private let detailViewSegueIdentifier = "movieDetailSegue"
    private var viewModel = MainViewModel(interactor: MainInteractor(repository: MainRepository()))
    
    @IBOutlet private weak var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = UIColor.createColor(color: .MovieListDarkBlue)
        }
    }
    
    // MARK: - setup methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        implementViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailViewSegueIdentifier,
            let detailViewEntity = sender as?DetailViewEntity,
            let detailViewController = segue.destination as? DetailViewController {
            detailViewController.setViewEntity(detailViewEntity: detailViewEntity)
        }
    }
    
    // MARK: - private methods
    private func implementViewModel() {
        viewModel.reloadTableView = {[weak self] in
            self?.loadingView.isHidden = true
            self?.tableView.reloadData()
        }
        
        viewModel.showError = {[weak self] msg in
            self?.loadingActivity.isHidden = true
            self?.retryButton.isHidden = false
            self?.showError(msg: msg)
            
        }
    }
    
    @IBAction func retryTap() {
        viewModel.retryLoadData()
    }
    
    private func updateBackgroundViewColor(cellIndex: Int) {
        if cellIndex == 0 {
            backgroundView.backgroundColor = UIColor.createColor(color: .MovieListDarkBlue)
        } else if cellIndex == viewModel.getListCount() - 1 {
            backgroundView.backgroundColor = UIColor.white
        }
    }
    
    private func openMovieDetails(id: Int) {
        
        if let detailViewEntity = viewModel.getDetailViewEntity(id: id) {
            performSegue(withIdentifier: detailViewSegueIdentifier, sender: detailViewEntity)
        }
    }
    
    private func loadMoreMovies() {
        viewModel.getMovies()
    }
    
    private func showError(msg: String) {
        let alert = UIAlertController(title: NSLocalizedString("alert.title", comment: ""), message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert.button", comment: ""), style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

// MARK: - extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, let cell = createHighlightCell() {
            return cell
        } else {
            let row = indexPath.row
            checkHasMoreCells(row: row)
            updateBackgroundViewColor(cellIndex: row)
            if let cell = createMovieCell(row: row) {
                return cell
            }
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 140
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView: HeaderView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?[0] as? HeaderView {
            if section == 0 {
                headerView.setStyleWithoutBackground()
            }
            
            let title = section == 0 ? NSLocalizedString("main.highlight_title", comment: "") : NSLocalizedString("main.movies_title", comment: "")
            headerView.setTitle(title: title)
            
            return headerView
        }
        
        return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        if let id = viewModel.getMovieBy(index: indexPath.row)?.id {
            openMovieDetails(id: id)
        }
    }
    
    // MARK: - AUXILIAR METHODS
    private func createHighlightCell() -> HighlightCell? {
        if let cell: HighlightCell = tableView.dequeueReusableCell(withIdentifier: "HighlightCell") as? HighlightCell {
            cell.setData(list: viewModel.getHighlightList())
            cell.selectedMovieId = {[weak self] id in
                self?.openMovieDetails(id: id)
            }
            return cell
        }
        return nil
    }
    
    private func createMovieCell(row: Int) -> MovieCell? {
        
        if let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell,
            let movie = viewModel.getMovieBy(index: row) {
            
            cell.setData(movieViewEntity: movie)
            return cell
        }
        return nil
    }
    
    private func checkHasMoreCells(row: Int) {
        if row == viewModel.getListCount() - 1 {
            loadMoreMovies()
        }
    }
    
}

