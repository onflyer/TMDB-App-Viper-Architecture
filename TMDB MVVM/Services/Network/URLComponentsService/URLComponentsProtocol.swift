//
//  RequestProtocol.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/12/24.
//

import Foundation

public protocol URLComponentsProtocol {
    var httpMethod: HTTPMethod { get }
    var host : String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
}

public extension URLComponentsProtocol {
    
    var httpMethod: HTTPMethod {
        .GET
    }
    var scheme: String {
        return "https"
    }
    var host: String {
        return "api.themoviedb.org"
    }
    var path: String {
        return ""
    }
    var headers: [String: String] {
        [:]
    }
    var params: [String: Any] {
        [:]
    }
    var urlParams: [String: String?] {
        [:]
    }
    
    func request() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        let timeStamp = "\(Date().timeIntervalSince1970)"

        /// Add default query params
        var queryParamsList: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: "89e4bae37305d94ef67db0a32d6e79ef"),
        ]

        if !urlParams.isEmpty {
            queryParamsList.append(contentsOf: urlParams.map { URLQueryItem(name: $0, value: $1) })
        }

        components.queryItems = queryParamsList

        guard let url = components.url else {
            throw  NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
       print("🚀 [REQUEST] [\(httpMethod.rawValue)] \(urlRequest), \(timeStamp)")
        return urlRequest
    }
}
