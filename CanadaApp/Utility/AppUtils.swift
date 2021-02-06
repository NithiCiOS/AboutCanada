//
//  AppUtils.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import UIKit


/// The `AppUtils` provides some facilities that can be used through out
/// the app development.
/// e.g : let _ = AppUtils.Screen.height
enum AppUtils {
    
    /// Screen Size Metrics
    enum Screen {
        
        /// Screen height
        static let height = UIScreen.main.bounds.height
        
        /// Screen width
        static let width = UIScreen.main.bounds.width
    }
}
