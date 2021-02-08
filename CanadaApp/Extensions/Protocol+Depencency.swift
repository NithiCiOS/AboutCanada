//
//  Protocol+Depencency.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import UIKit

/// Protocol supports to maintain the dependency injection of service.
/// Likewise we can create Model dependency and Parameter dependencies.
protocol ServiceDependency {
    associatedtype Service
    init(with service: Service)
}

/// Controller dependency with ViewModel.
protocol ControllerDependency {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
}

/// An extension that sets the dependent view model to the controller.
extension ControllerDependency where Self: UIViewController {
    static func instantiate(viewModel: ViewModel) -> Self {
        var controller = Self()
        controller.viewModel = viewModel
        return controller
    }
}
