//
//  MockNetworkSession.swift
//  CanadaAppTests
//
//  Created by CVN on 06/02/21.
//

import Foundation
@testable import CanadaApp

class MockNetworkSession: NetworkSession {
    func loadData<T: Codable>(from request: URLRequest, completion: @escaping  ((Result<T, AppNetworkError>) -> Void)) {
        
    }
}
