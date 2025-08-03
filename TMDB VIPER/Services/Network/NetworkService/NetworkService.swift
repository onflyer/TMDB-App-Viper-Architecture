//
//  NetworkService.swift
//  TMDB_VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import Foundation

 final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    /// Sends a request built from URLComponentsProtocol, returns raw Data
     func makeRequest(request: URLComponentsProtocol) async throws -> Data {
        let urlRequest = try request.request()
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        return data
    }

    /// Sends a request and decodes response into a Decodable model
     func makeRequest<T: Decodable>(request: URLComponentsProtocol, responseType: T.Type) async throws -> T {
        let data = try await makeRequest(request: request)
        return try decoder.decode(T.self, from: data)
    }
}
