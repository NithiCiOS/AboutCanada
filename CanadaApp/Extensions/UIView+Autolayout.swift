//
//  UIView+Autolayout.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import UIKit

extension UIView {
    
    /// Programmatically setups the layout anchor.
    ///
    /// - Parameters:
    ///   - top: Optional `NSLayoutYAxisAnchor` represents the top constraint.
    ///   - bottom: Optional `NSLayoutYAxisAnchor` represents the bottom constraint.
    ///   - trailing: Optional `NSLayoutXAxisAnchor` represents the trailing constraint.
    ///   - leading: Optional `NSLayoutXAxisAnchor` represents the leading constraint.
    ///   - padding: Optional `UIEdgeInsets` represents the padding edges of view.
    func setupAnchors(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = leading {
            leadingAnchor.constraint(
                equalTo: leading,
                constant: padding.left
            ).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(
                equalTo: trailing,
                constant: -padding.right
            ).isActive = true
        }
        
        if let top = top {
            topAnchor.constraint(
                equalTo: top,
                constant: padding.top
            ).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(
                equalTo: bottom,
                constant: -padding.bottom
            ).isActive = true
        }
        
        if size.width != .zero {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != .zero {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
