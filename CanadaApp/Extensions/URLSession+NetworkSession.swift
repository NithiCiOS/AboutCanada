//
//  URLSession+NetworkSession.swift
//  CanadaApp
//
//  Created by CVN on 07/02/21.
//

import Foundation
import UIKit

protocol NetworkSession {
    func loadData<T: Codable>(from request: URLRequest, completion: @escaping ((Result<T, AppNetworkError>) -> Void))
    
    func loadImageData(from imageUrl: URL, completion: @escaping ((Result<UIImage, AppNetworkError>) -> Void))
}

extension URLSession: NetworkSession {
    func loadData<T: Codable>(
        from request: URLRequest,
        completion: @escaping ((Result<T, AppNetworkError>) -> Void)) {
        
        if let hasConnection = ConnectionObserver.shared.reachability.value,
           !hasConnection {
            completion(.failure(.noInternet))
            return
        }
        
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
    
    
    func loadImageData(
        from imageUrl: URL,
        completion: @escaping ((Result<UIImage, AppNetworkError>) -> Void)
    ) {
        let task = dataTask(with: imageUrl) { imageData, urlResponse, error in
            guard
                let imageData = imageData,
                let image = UIImage(data: imageData),
                error == nil
            else {
                completion(.failure(.imageNotLoaded))
                return
            }
            completion(.success(image))
        }
        
        task.resume()
    }
}


import Network

final class ConnectionObserver {
    static let shared = ConnectionObserver()
    
    let reachability = DataBinding<Bool>()
    
    private var networkMonitor: NWPathMonitor!
     
    private init() {
        networkMonitor = NWPathMonitor()
        startMonitoring()
    }
    
    private func startMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let weakSelf = self else { return }
            switch path.status {
                case .satisfied, .unsatisfied:
                    weakSelf.reachability.value = true
                case .requiresConnection:
                    weakSelf.reachability.value = false
                @unknown default:
                    weakSelf.reachability.value = false
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        networkMonitor.start(queue: queue)
    }
}
