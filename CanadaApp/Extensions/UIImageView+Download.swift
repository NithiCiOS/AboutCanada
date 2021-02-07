//
//  UIImageView+Download.swift
//  CanadaApp
//
//  Created by CVN on 07/02/21.
//

import Foundation
import UIKit

extension UIImageView {
    func getImage(
        from url: String?,
        session: NetworkSession = URLSession.shared
    ) {
        guard
            let imageURL = url,
            let requestURL = URL(string: imageURL)
        else {
            // set placeholder image
            return
        }
        
        if let image = ImageCache.shared.getImage(forKey: imageURL) {
            print("ImageURL ===>", imageURL)
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        
        session.loadImageData(from: requestURL) { result in
            switch  result {
                case .success(let image):
                    ImageCache.shared.save(image: image, forKey: imageURL)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                case .failure(_):
                    // Placeholder image.
                    let placeholderImage = UIImage(named: "placeholder")
                    ImageCache.shared.save(image: placeholderImage ?? UIImage(), forKey: imageURL)
                    DispatchQueue.main.async {
                        self.image = placeholderImage
                    }
            }
        }
    }
}
