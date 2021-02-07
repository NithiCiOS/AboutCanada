//
//  ImageCache.swift
//  CanadaApp
//
//  Created by CVN on 07/02/21.
//

import Foundation
import UIKit

/**
 *  The intension of this `singleton` class is to maintain images in application cache memory.
 *  - seeAlso: `getImage(forKey:)`
 *  - seeAlso: `save(image:forKey:)`
 */
class ImageCache {
    
    /// `NSCache` represents to maintain image caches.
    private let cache = NSCache<NSString, UIImage>()
    
    /// `NSObjectProtocol` represents to performs the event when system receives the memory warning.
    private var observer: NSObjectProtocol!
    
    /// `static` instance of shared memory.
    static let shared = ImageCache()
    
    /// Initializer
    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil, queue: nil) { [weak self] notification in
                self?.cache.removeAllObjects()
        }
    }
    
    /// Get image for the equivalent key url.
    /// - Parameter key: `String` represents the image url.
    /// - Returns: Optional `UIImage`.
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    /// Save downloaded image
    /// - Parameters:
    ///   - image: `UIImage` represents the downloaded image.
    ///   - key: `String` represents the key of the image.
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }
}
