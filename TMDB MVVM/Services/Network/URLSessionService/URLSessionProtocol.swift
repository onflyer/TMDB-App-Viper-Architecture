//
//  NetworkManager.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/13/24.
//

import Foundation

/// The network manager protocol.
/// It is responsible for making network requests.
public protocol URLSessionProtocol {
    func makeRequest(with requestData: URLComponentsProtocol) async throws -> Data
}

public class DefaultURLSessionService: URLSessionProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    /// Makes a network request.
    ///
    /// - Parameter requestData: The request data
    /// - Returns: The response data
    /// - Throws: An error if the request fails.
    /// - Note: This method is asynchronous.
    /// - Important: The request data should conform to `RequestProtocol`.
    /// - SeeAlso: `RequestProtocol`
    public func makeRequest(with requestData: URLComponentsProtocol) async throws -> Data {
        let request = try requestData.request()
        var responseStatusCode: Int?
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...300) ~= httpResponse.statusCode else {
                responseStatusCode = (response as? HTTPURLResponse)?.statusCode
                throw NetworkError.invalidResponse
            }
            print(request)
            print(responseStatusCode as Any)
            return data
        } catch {
            print(error)
            throw error
        }
    }
    
}
