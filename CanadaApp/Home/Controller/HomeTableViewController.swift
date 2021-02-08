//
//  HomeTableViewController.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import UIKit

class HomeTableViewController: UITableViewController, ControllerDependency {
    
    var viewModel: HomeViewModelInterface!

    typealias ViewModel = HomeViewModelInterface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTableView()
        self.setupNavBarTitle()
        self.showNoInternetView()
    }
    
    private func setupNavBarTitle() {
        self.navigationItem.title = self.viewModel.navBarTitle
    }
    
    private func prepareTableView() {
        self.tableView.register(CanadaInfoCell.self, forCellReuseIdentifier: CanadaInfoCell.reuseId)
        self.tableView.estimatedRowHeight = 100
    }
}

extension HomeTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.canadaDetails.value?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CanadaInfoCell.reuseId, for: indexPath) as? CanadaInfoCell
        else {
            return UITableViewCell()    // This return won't happen.
        }
        let detail = self.viewModel.canadaDetails.value?[indexPath.row]
        cell.canadaDetail = detail
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
