//
//  NetworkServiceMock.swift
//  TMDB AppTests
//
//  Created by Aleksandar Milidrag on 4/20/24.
//

import Foundation
@testable import TMDB_VIPER

class NetworkServiceMock: NetworkServiceProtocol {
    
    var urlSession: URLSessionProtocol
    var parser: DataParserProtocol
    
    init(urlSession: URLSessionProtocol, parser: DataParserProtocol) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    func makeRequest<T>(with urlComponents: URLComponentsProtocol) async throws -> T where T : Decodable {
        let data = try await urlSession.makeRequest(with: urlComponents)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    
}
