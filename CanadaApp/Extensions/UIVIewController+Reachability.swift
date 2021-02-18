//
//  UIVIewController+Reachability.swift
//  CanadaApp
//
//  Created by CVN on 08/02/21.
//

import UIKit

extension UIViewController {
    
    /// Computational property support to get the network label at the extentioal level.
    func noNetworkLabel() -> UILabel {
        let networkLabel = UILabel()
        networkLabel.tag = 1001
        networkLabel.text = "Internet is not available."
        networkLabel.font = .boldSystemFont(ofSize: 20)
        networkLabel.textColor = .red
        networkLabel.textAlignment = .center
        return networkLabel
    }
    
    /// This is an additional execution of `UIViewController`.
    /// Hence we can re-use this for all the UIViewcontrollers.
    func showNoInternetView() {
        guard let _ = self.navigationController else { return }
        // Execute during view load
        updateNavigationBar()
    }
    
    /// Observe the connection status, and decides to show or remove.
    func updateNavigationBar() {
        DispatchQueue.main.async {
            if ConnectionObserver.shared.isConnected {
                self.navigationItem.titleView = nil
            } else {
                self.navigationItem.titleView = self.noNetworkLabel()
            }
        }
    }
}
