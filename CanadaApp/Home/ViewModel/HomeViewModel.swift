//
//  HomeViewModel.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import Foundation

protocol HomeViewModelInterface: AnyObject {
    
    var navBarTitle: String? { get set }
    
    var service: NetworkServiceInterface { get set }
    
    var canadaDetails: DataBinding<[CanadaDetail]> { get set }
    
    var refreshTableView: DataBinding<Bool> { get set }
    
    init(with service: NetworkServiceInterface)
    
    func getDetail()
}

extension HomeViewModelInterface {
    init(with service: NetworkServiceInterface = NetworkService()) {
        self.init(with: service)
    }
}
// MARK: - HomeViewModel

/**
 * A `HomeViewModel`, that supplies the required data model to the controller.
 */
final class HomeViewModel: HomeViewModelInterface {
    
    // MARK: - Instance Variable
    
    /// `NetworkServiceInterface` represents the service that has been used by this viewmodel.
    var service: NetworkServiceInterface
    
    /// An array of Observer.
    var canadaDetails: DataBinding<[CanadaDetail]>
    
    /// Refresh the tableview when async network call was completed.
    var refreshTableView: DataBinding<Bool>
    
    /// `String` represents the title of navigation bar.
    var navBarTitle: String?
    
    // MARK: - Methods
    
    /// Initializer
    /// - Parameter service: `NetworkServiceInterface` mock service is also can be inject here.
    init(with service: NetworkServiceInterface) {
        self.service = service
        self.refreshTableView = DataBinding<Bool>()
        self.canadaDetails = DataBinding<[CanadaDetail]>()
        self.getDetail()
    }
    
    // MARK: - Custom method.
    
    /// Get the detail of about canada.
    func getDetail() {
        self.service.getAboutCanada { [weak self] result in
            guard
                let weakSelf = self,
                let detail = result
            else {
                return
            }
            let filteredRows = detail.rows?.filter {
                $0.title != nil &&
                $0.rowDescription != nil &&
                $0.imageHref != nil
            }
            weakSelf.canadaDetails.value = filteredRows
            weakSelf.navBarTitle = detail.about
            weakSelf.refreshTableView.value = true
        }
    }
}
