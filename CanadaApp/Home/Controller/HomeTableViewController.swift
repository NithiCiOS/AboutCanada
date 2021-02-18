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
        self.showNoInternetView()
        self.prepareTableView()
        self.setupNavBarTitle()
        self.observeTableViewRefresh()
        self.reloadInfo()
    }
    
    private func setupNavBarTitle() {
        self.navigationItem.title = self.viewModel.navBarTitle
    }
    
    private func prepareTableView() {
        self.tableView.register(CanadaInfoCell.self, forCellReuseIdentifier: CanadaInfoCell.reuseId)
        self.tableView.estimatedRowHeight = 100
    }
    
    private func observeTableViewRefresh() {
        self.viewModel.refreshTableView.bind { [weak self] refresh in
            if let refreshView = refresh, refreshView {
                DispatchQueue.main.async { [weak self] in
                    // Avoid one more reference count.
                    guard let weakSelf = self else { return }
                    weakSelf.tableView.reloadData()
                    weakSelf.setupNavBarTitle()
                }
            }
        }
    }
    
    private func reloadInfo() {
        ConnectionObserver.shared.netStatusChangeHandler = { [unowned self] in
            self.updateNavigationBar()
            if ConnectionObserver.shared.isConnected {
                self.viewModel.getDetail()
            }
        }
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
