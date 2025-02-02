//
//  URLSessionMockService.swift
//  TMDB AppTests
//
//  Created by Aleksandar Milidrag on 4/20/24.
//

import Foundation
@testable import TMDB_VIPER

class URLSessionMockService: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    func makeFakeRequest() async throws -> Data {
        if let data = data {
            return data
        }
        if let error = error {
            throw error
        }
        fatalError("URLSession mock not properly setup")
    }
    
    func makeRequest(with requestData: URLComponentsProtocol) async throws -> Data {
       try await makeFakeRequest()
    }
    
    
}
