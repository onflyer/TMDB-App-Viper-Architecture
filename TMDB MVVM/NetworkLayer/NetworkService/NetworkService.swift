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

// MARK: - Default Request Manager
public class DefaultNetworkService: NetworkServiceProtocol {
    public let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = DefaultURLSessionService()) {
        self.urlSession = urlSession
    }

    /// Makes a network request.
    ///
    /// - Parameter requestData: The request data to be sent.
    /// - Returns: The response data decoded to the specified type.
    /// - Throws: An error if the request fails.
    /// - Note: This method is asynchronous.
    /// - Important: The request data should conform to `RequestProtocol`.
    /// - SeeAlso: `RequestProtocol`
    /// - SeeAlso: `NetworkError`
    public func makeRequest<T: Decodable>(with urlComponents: URLComponentsProtocol) async throws -> T {
        let data = try await urlSession.makeRequest(with: urlComponents)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
}

// MARK: - Returns Data Parser -

public extension NetworkServiceProtocol {
    var parser: DataParserProtocol {
        return DefaultDataParser()
    }
}
