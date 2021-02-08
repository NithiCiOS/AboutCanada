//
//  NetworkService.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import Foundation

protocol NetworkServiceInterface {
    init(session: NetworkSession)
    func getAboutCanada(completion: @escaping ((AboutCanada?) -> Void))
}

extension NetworkServiceInterface {
    init(session: NetworkSession = URLSession.shared) {
        self.init(session: session)
    }
}

/// Network Service.
/// Intead of singleton, it's better to prepare service layer as `struct`.
/// So that we can avoid memory foot prints of the layer, throughout the application.
struct NetworkService: NetworkServiceInterface {
    
    /// `NetworkSession` represents the session type.
    private let session: NetworkSession
    
    /// Initializer
    /// - Parameter session: `NetworkSession` to perform the request.
    init(session: NetworkSession) {
        self.session = session
    }
    
    /// Network API call to to get the information about Canada.
    /// - Parameter completion: A closure that have the completion of `AboutCanada` model.
    func getAboutCanada(completion: @escaping ((AboutCanada?) -> Void)) {
        guard
            let urlRequest = NetworkRequest.aboutCanada(.get, nil).requestType
        else {
            assertionFailure("Unwrapped URL request..!")
            return
        }
        self.session.loadData(from: urlRequest) { (result: Result<AboutCanada, AppNetworkError>) in
            switch result {
                case .success(let about):
                    completion(about)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
            }
        }
    }
}
