//
//  AppNetworkError.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import Foundation

enum AppNetworkError: Error {
    
    case jsonNotLoaded
    
    case decodingProblem
    
    case requestNotFullFill
    
    case serverOutOfService
    
    case unknown
    
    case responseError(Error)
    
    case imageNotLoaded
    
    case noInternet
    
    var description: String {
        switch self {
            case .jsonNotLoaded, .decodingProblem:
                return "There may be problem in json parse"
                
            case .requestNotFullFill:
                return "Invalid request"
                
            case .serverOutOfService:
                return "Unable to reach server, may be server problem, create a ticket to the server team"
                
            case .unknown:
                return "Unknown issue"
                
            case .responseError (let error):
                #if DEBUG
                print(error)
                #endif
                return error.localizedDescription
                
            case .imageNotLoaded:
                return "Image is not downloaded."
            
            case .noInternet:
                return "Internet connection appears to be offline."
        }
    }
    
}
