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
    
    init(with service: NetworkServiceInterface)
    
    func getDetail()
}

extension HomeViewModelInterface {
    init(with service: NetworkServiceInterface = NetworkService()) {
        self.init(with: service)
    }
}

final class HomeViewModel: HomeViewModelInterface {
    var service: NetworkServiceInterface
    
    var canadaDetails: DataBinding<[CanadaDetail]>
    
    var navBarTitle: String?
    
    init(with service: NetworkServiceInterface) {
        self.service = service
        self.canadaDetails = DataBinding<[CanadaDetail]>()
        self.getDetail()
    }
    
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
        }
    }
    
}
