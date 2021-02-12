//
//  UIVIewController+Reachability.swift
//  CanadaApp
//
//  Created by CVN on 08/02/21.
//

import UIKit

extension UIViewController {

    func showNoInternetView() {
        
        let navigationView = self.navigationController?.view ?? self.view
        
        guard let displayView = navigationView else { return }
        
        // Avoid duplication
        let noInternetLabel = displayView.subviews.first(where: { $0.tag == 1001 })
        
        if noInternetLabel == nil {
            let networkLabel = UILabel()
            networkLabel.tag = 1001
            networkLabel.text = "Internet is not available."
            networkLabel.font = .boldSystemFont(ofSize: 20)
            networkLabel.textColor = .white
            networkLabel.textAlignment = .center
            networkLabel.backgroundColor = .red
            displayView.addSubview(networkLabel)
            networkLabel.setupAnchors(
                top: displayView.topAnchor,
                trailing: displayView.trailingAnchor,
                leading: displayView.leadingAnchor,
                size: .init(width: 0, height: 30)
            )
            displayView.bringSubviewToFront(networkLabel)
            networkLabel.isHidden = ConnectionObserver.shared.isConnected
        }
    }
    
    /// Hide or shows the network not available label.
    func showTheLabel(_ show: Bool) {
        print("showww ==", show)
        // Observed NWPath delay here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let navigationView = self.navigationController?.view ?? self.view
            
            guard let displayView = navigationView else { return }
            
            // Get the exact view in extension.
            let noInternetLabel = displayView.subviews.first(where: { $0.tag == 1001 })
            noInternetLabel?.isHidden = show
        }
    }
}
