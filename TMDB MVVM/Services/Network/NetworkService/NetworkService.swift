//
//  NetworkService.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/13/24.
//

import Foundation

// MARK: - Request Manager Protocol -

public protocol NetworkServiceProtocol {
    var urlSession: URLSessionProtocol { get }
    var parser: DataParserProtocol { get }
    func makeRequest<T: Decodable>(with urlComponents: URLComponentsProtocol) async throws -> T
}


// MARK: - Returns Data Parser -

public extension NetworkServiceProtocol {
    var parser: DataParserProtocol {
        return DefaultDataParser()
    }
}
