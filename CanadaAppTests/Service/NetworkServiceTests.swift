//
//  NetworkServiceTests.swift
//  CanadaAppTests
//
//  Created by CVN on 09/02/21.
//

import XCTest
@testable import CanadaApp

/**
 * The intention of this tests is to verify the actual `NetworkService` executions.
 */
class NetworkServiceTests: XCTestCase {
    // MARK: - Intance Variables
    
    /// System-Under-Test
    var sutNetworkService: NetworkService?
    
    /// `MockNetworkSession` respresents the mock session.
    let mockSession =  MockNetworkSession()
    
    // MARK: - Lifecycle
    
    /// Call everytime before start the testcase.
    override func setUp() {
        sutNetworkService = NetworkService(session: mockSession)
    }
    
    /// Call everytime when testcase complete its process.
    override func tearDown() {
        sutNetworkService = nil
    }
    
    // MARK: - Test cases.
    
    /// Verifies the `loadData(from:completion:)` execution.
    func testLoadData() {
        // Arrange
        
        // Act
        sutNetworkService?.getAboutCanada(completion: { result in
        })

        XCTAssertTrue(mockSession.loadDataCalled)
        XCTAssertEqual(mockSession.loadDataCallCount, 1)
    }
    
    /// Verifies the `loadImageData(from:completion:)` execution.
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
