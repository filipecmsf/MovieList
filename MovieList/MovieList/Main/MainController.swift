//
//  ViewController.swift
//  MovieList
//
//  Created by Filipe Faria on 01/08/19.
//  Copyright © 2019 Filipe Faria. All rights reserved.
//

import Alamofire
import UIKit

class MainViewController: UIViewController {
    
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
    
    private var viewModel: MainViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel()
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, let cell: HighlightCell = tableView.dequeueReusableCell(withIdentifier: "HighlightCell") as? HighlightCell {
            return cell
        } else if let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell {
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 300 : 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView: HeaderView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?[0] as? HeaderView {
            if section == 0 {
                headerView.setStyleWithoutBackground()
            }
            return headerView
        }
        
        return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
