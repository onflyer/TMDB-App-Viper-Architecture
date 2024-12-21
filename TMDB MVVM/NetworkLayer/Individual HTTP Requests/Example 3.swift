//
//  SearchMoviesRequest.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/17/24.
//

import Foundation

enum SearchMoviesRequest: URLComponentsProtocol {
    
    case searchMovies(query: String)
    
    var path: String {
        switch self {
        case .searchMovies:
            return "/3/search/movie"
        }
    }
    
    var httpMethod: HTTPMethod {
        .GET
    }
    
    var urlParams: [String: String?] {
        switch self {
        case .searchMovies(let query):
            return ["language": "en-US", "include_adult": "true", "region": "US", "query": query]
        }
        
    }
}
