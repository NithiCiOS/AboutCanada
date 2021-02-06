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
    private let session: NetworkSession
    
    init(session: NetworkSession) {
        self.session = session
    }
    
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

protocol NetworkSession {
    func loadData<T: Codable>(from request: URLRequest, completion: @escaping ((Result<T, AppNetworkError>) -> Void))
}

extension URLSession: NetworkSession {
    func loadData<T: Codable>(
        from request: URLRequest,
        completion: @escaping ((Result<T, AppNetworkError>) -> Void)) {
        let task = dataTask(with: request) { networkData, response, error in
            guard
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                if let error = error {
                    completion(.failure(.responseError(error)))
                    return
                }
                completion(.failure(.unknown))
                return
            }
            
            switch response.statusCode {
                /// Generally a success response.
                /// Some times server response throws 200, but validation may be fails.
                /// In that scenario we have to prepare the repective model to handle that.
                case 200...299:
                    if let data = networkData,
                       let latin1String = String(data: data, encoding: .isoLatin1),
                       let latin1Data = latin1String.data(using: .utf8, allowLossyConversion: true),
                       let responseModel = try? JSONDecoder().decode(T.self, from: latin1Data) {
                        completion(.success(responseModel))
                        return
                    }
                    completion(.failure(.decodingProblem))
                    
                case 300...399: // Error in request.
                    completion(.failure(.requestNotFullFill))
                    
                case 400...600: // Server error.
                    completion(.failure(.serverOutOfService))
                    
                default:
                    completion(.failure(.unknown))
            }
        }
        task.resume()
    }
}
