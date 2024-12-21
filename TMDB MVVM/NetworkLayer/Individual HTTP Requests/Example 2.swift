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
        case .getMovieById(movieId: let movieId):
            return "/3/movie/\(movieId)"
        }
    }
        
    var headers: [String : String] {
        switch self {
        case .getNowPlayingMovies(page: _):
            return [:]
        case .getUpcomingMovies:
            return [:]
        case .getTopRatedMovies:
            return [:]
        case .getPopularMovies:
            return [:]
        case .getMovieById(movieId: _):
            return [:]
        }
    }
    
    var urlParams: [String : String?] {
        switch self {
        case .getNowPlayingMovies(page: let page):
            return ["page": String(page)]
        case .getUpcomingMovies(page: let page):
           return ["page": String(page)]
        case .getTopRatedMovies(page: let page):
           return ["page": String(page)]
        case .getPopularMovies(page: let page):
           return ["page": String(page)]
        case .getMovieById( _):
            return ["append_to_response": "videos,credits"]
        }
    }
}

 

    //MARK: HEADERS FOR POST FAVORITE
//return ["content-type": "application/json", "accept": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4OWU0YmFlMzczMDVkOTRlZjY3ZGIwYTMyZDZlNzllZiIsInN1YiI6IjY0OGVmNWE0NDJiZjAxMDBhZTMxZTM2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7PAEwgGiWHGXPoGblvW0i-SHZQAqL2UhOmQ1zwoSvVM"]
