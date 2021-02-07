//
//  MockNetworkSession.swift
//  CanadaAppTests
//
//  Created by CVN on 06/02/21.
//

import Foundation
import UIKit
@testable import CanadaApp

class MockNetworkSession: NetworkSession {
    func loadData<T: Codable>(from request: URLRequest, completion: @escaping  ((Result<T, AppNetworkError>) -> Void)) {
        
    }
    
    func loadImageData(
        from imageUrl: URL,
        completion: @escaping ((Result<UIImage, AppNetworkError>) -> Void)
    ) {
        
    }
    
}
