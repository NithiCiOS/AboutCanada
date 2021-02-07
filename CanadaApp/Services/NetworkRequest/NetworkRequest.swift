//
//  NetworkRequest.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import Foundation

/// Note: Actually this could be a part of `.config` file, then we can configure build for multiple environments, like dev, staging, and release.
fileprivate let baseURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/"

/// HTTP type.
enum HTTPtype: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Network request type
enum NetworkRequest {
    
    /// In this request, the same url can be used for `post` or some other type request.
    /// Hence it's better it should be have that and also future developer will get to know the type of this request.
    /// Note: - When you call this request in `postman` the content-type is text/plain, so we need to convert that string into data once again.
    case aboutCanada(HTTPtype, Data?)
    
    /// All system request has been formed here.
    var requestType: URLRequest? {
        switch self {
            case .aboutCanada (let type, let data):
                let urlString = baseURL + "facts.json"
                if let url = URL(string: urlString) {
                    var request =  URLRequest(
                        url: url,
                        cachePolicy: .returnCacheDataElseLoad,
                        timeoutInterval: 120
                    )
                    request.httpMethod = type.rawValue
                    request.httpBody = data
                    return request
                }
                return nil
        }
    }
}
