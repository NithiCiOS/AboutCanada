//
//  NetworkServiceTests.swift
//  CanadaAppTests
//
//  Created by CVN on 09/02/21.
//

import XCTest
@testable import CanadaApp

class NetworkServiceTests: XCTestCase {
    
    /// System-Under-Test
    var sutNetworkService: NetworkService?
    
    let mockSession =  MockNetworkSession()
    
    override func setUp() {
        sutNetworkService = NetworkService(session: mockSession)
    }
    
    override func tearDown() {
        sutNetworkService = nil
    }
    
    func testLoadData() {
        // Arrange
        
        // Act
        sutNetworkService?.getAboutCanada(completion: { result in
        })
        
        // Assert
        XCTAssertTrue(mockSession.loadDataCalled)
        XCTAssertEqual(mockSession.loadDataCallCount, 1)
    }
    
    func testLoadImageData() {
        // Arrange
        
        // Act
        UIImageView().getImage(
            from: "http://test.img",
            session: mockSession
        )
        
        // Assert
        XCTAssertTrue(mockSession.loadImageDataCalled)
        XCTAssertEqual(mockSession.loadImageDataCallCount, 1)
    }

}
