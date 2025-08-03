//
//  MoviesRequest.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/14/24.
//

import Foundation

enum MoviesRequest: URLComponentsProtocol {
    
    case getNowPlayingMovies(page: Int)
    case getUpcomingMovies(page: Int)
    case getTopRatedMovies(page: Int)
    case getPopularMovies(page: Int)
    case getMovieById(movieId: Int)
    
    var httpMethod: HTTPMethod {
        .GET
    }
    
    var path: String {
        switch self {
        case .getNowPlayingMovies:
            return "/3/movie/now_playing"
        case .getUpcomingMovies:
            return "/3/movie/upcoming"
        case .getTopRatedMovies:
            return "/3/movie/top_rated"
        case .getPopularMovies:
            return "/3/movie/popular"
        case .getMovieById(let movieId):
            return "/3/movie/\(movieId)"
        }
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var urlParams: [String: String?] {
        switch self {
        case .getNowPlayingMovies(let page),
             .getUpcomingMovies(let page),
             .getTopRatedMovies(let page),
             .getPopularMovies(let page):
            return ["page": String(page)]
        case .getMovieById:
            return ["append_to_response": "videos,credits"]
        }
    }
    
    var body: Encodable? {
        nil
    }
}

