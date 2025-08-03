//
//  NetworkService.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/13/24.
//

import Foundation

// MARK: - Request Manager Protocol -

public protocol NetworkServiceProtocol {
    func makeRequest(request: URLComponentsProtocol) async throws -> Data
    func makeRequest<T: Decodable>(request: URLComponentsProtocol, responseType: T.Type) async throws -> T
}

