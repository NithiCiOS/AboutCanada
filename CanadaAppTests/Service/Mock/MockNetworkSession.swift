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
    
    var loadDataCalled = false
    var loadDataCallCount = 0
    
    func loadData<T: Codable>(from request: URLRequest, completion: @escaping  ((Result<T, AppNetworkError>) -> Void)) {
        loadDataCalled = true
        loadDataCallCount += 1
    }
    
    var loadImageDataCalled = false
    var loadImageDataCallCount = 0
    func loadImageData(
        from imageUrl: URL,
        completion: @escaping ((Result<UIImage, AppNetworkError>) -> Void)
    ) {
        loadImageDataCalled = true
        loadImageDataCallCount += 1
    }
}
