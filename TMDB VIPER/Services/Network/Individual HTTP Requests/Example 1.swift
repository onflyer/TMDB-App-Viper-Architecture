//
//  FavoriteMoviesRequest.swift
//  TMDB App
//
//  Created by Aleksandar Milidrag on 3/17/24.
//

import Foundation

enum FavoriteMoviesRequest : URLComponentsProtocol {
    
    case getFavoriteMovies(page: Int)
    case postMovieToFavorites(movieId: Int)
    case deleteMovieFromFavorites(movieId: Int)
    
    var path: String {
        switch self {
        case .getFavoriteMovies:
            return "/3/account/20029223/favorite/movies"
        case .postMovieToFavorites(movieId: _):
            return "/3/account/20029223/favorite"
        case .deleteMovieFromFavorites(movieId: _):
            return "/3/account/20029223/favorite"
        }
    }
    
    var urlParams: [String : String?] {
        switch self {
        case .getFavoriteMovies( let page):
            return ["session_id": "954a0e7f7e9c282ade3daaab053db4e20c870209","page": String(page), "language": "US", "sort_by": "created_at.desc"]
        case .postMovieToFavorites(movieId: _):
            return ["session_id": "954a0e7f7e9c282ade3daaab053db4e20c870209"]
        case .deleteMovieFromFavorites(movieId: _):
            return ["session_id": "954a0e7f7e9c282ade3daaab053db4e20c870209"]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .getFavoriteMovies( _):
            return [:]
        case .postMovieToFavorites( _):
           return ["content-type": "application/json", "accept": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4OWU0YmFlMzczMDVkOTRlZjY3ZGIwYTMyZDZlNzllZiIsInN1YiI6IjY0OGVmNWE0NDJiZjAxMDBhZTMxZTM2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7PAEwgGiWHGXPoGblvW0i-SHZQAqL2UhOmQ1zwoSvVM"]
        case .deleteMovieFromFavorites(movieId: _):
           return ["content-type": "application/json", "accept": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4OWU0YmFlMzczMDVkOTRlZjY3ZGIwYTMyZDZlNzllZiIsInN1YiI6IjY0OGVmNWE0NDJiZjAxMDBhZTMxZTM2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7PAEwgGiWHGXPoGblvW0i-SHZQAqL2UhOmQ1zwoSvVM"]
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getFavoriteMovies( _):
           return [:]
        case .postMovieToFavorites(let movieId):
            return ["media_type": "movie", "media_id" : movieId, "favorite": true]
        case .deleteMovieFromFavorites(movieId: let movieId):
            return ["media_type": "movie", "media_id" : movieId, "favorite": false]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getFavoriteMovies(_):
            return .GET
        case .postMovieToFavorites(_):
            return .POST
        case .deleteMovieFromFavorites(movieId: _):
            return .POST
        }
    }
}
