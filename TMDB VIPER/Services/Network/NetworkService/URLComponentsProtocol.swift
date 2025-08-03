//
//  RequestProtocol.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/12/24.
//

import Foundation

// MARK: - HTTP Method

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

// MARK: - URLComponentsProtocol

public protocol URLComponentsProtocol {
    var httpMethod: HTTPMethod { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var urlParams: [String: String?] { get }
    var body: Encodable? { get }
}

// MARK: - Default implementation

public extension URLComponentsProtocol {
    
    // Default values
    var httpMethod: HTTPMethod { .GET }
    var scheme: String { "https" }
    var host: String { "api.themoviedb.org" }
    var path: String { "" }
    var headers: [String: String] { [:] }
    var urlParams: [String: String?] { [:] }
    var body: Encodable? { nil }
    
    /// Builds a URLRequest based on protocol properties
    func request() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        // Default query param (API key)
        var queryParamsList: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: "89e4bae37305d94ef67db0a32d6e79ef")
        ]
        
        // Add custom query params
        if !urlParams.isEmpty {
            queryParamsList.append(contentsOf: urlParams.map { URLQueryItem(name: $0, value: $1) })
        }
        
        components.queryItems = queryParamsList
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        // Add headers
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        // Encode body if present
        if let body = body {
            let encoder = JSONEncoder()
            urlRequest.httpBody = try encoder.encode(AnyEncodable(body))
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}

// MARK: - Type-Erased AnyEncodable

/// so i can use body in extension
private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self.encodeFunc = encodable.encode(to:)
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
