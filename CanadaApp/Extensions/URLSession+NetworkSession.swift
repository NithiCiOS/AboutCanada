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
        
        if !ConnectionObserver.shared.isConnected {
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
    
    // MARK: - Properties
    
    static let shared = ConnectionObserver()
    
    var monitor: NWPathMonitor?
    
    var isMonitoring = false
    
    var didStartMonitoringHandler: (() -> Void)?
    
    var didStopMonitoringHandler: (() -> Void)?
    
    var netStatusChangeHandler: (() -> Void)?
    
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    
    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
        
        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    
    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    
    // MARK: - Init & Deinit
    
    private init() {
        startMonitoring()
    }
    
    
    deinit {
        stopMonitoring()
    }
    
    
    // MARK: - Method Implementation
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
    
}
