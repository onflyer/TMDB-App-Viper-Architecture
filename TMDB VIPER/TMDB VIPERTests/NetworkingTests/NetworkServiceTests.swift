//
//  NetworkServiceTests.swift
//  TMDB AppTests
//
//  Created by Aleksandar Milidrag on 4/20/24.
//

import Foundation
import XCTest
@testable import TMDB_VIPER


class NetworkServiceTests: XCTestCase {
    
    func test_whenMockDataPassed_souldReturnProperResponse() async throws {
        
        let urlComponentsMock = URLComponentsMock(httpMethod: .GET )
        let urlSessionMock = URLSessionMockService()
        
        let parser = DataParserMock()
        
        let expectedData: String = "Response data"
        
        urlSessionMock.data = try JSONEncoder().encode(expectedData)
       
        let sut = NetworkServiceMock(urlSession: urlSessionMock, parser: parser)
        
        let result: String = try await sut.makeRequest(with: urlComponentsMock)
        print(result, expectedData)
        
        XCTAssertEqual(result, expectedData)
    }
    
    func test_whenMockErrorPassed_shouldReturnFailure() async throws {
        
        enum NetworkErrorMock: Error {
            case someError
        }
        
        let urlComponentsMock = URLComponentsMock(httpMethod: .GET)
        let urlSessionMock = URLSessionMockService()
        let parser = DataParserMock()
        
        let expectedError = NSError(domain: "Network", code: 400)
        urlSessionMock.error = expectedError
        
        let sut = NetworkServiceMock(urlSession: urlSessionMock, parser: parser)
        
        do {
           let _ = try await sut.makeRequest(with: urlComponentsMock) as String
            XCTFail("Expected to throw an error, but it did not")
        } catch let error as NSError {
            XCTAssertEqual(error, expectedError)
        }
        
    }
}
