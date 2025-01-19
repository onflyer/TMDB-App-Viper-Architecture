//
//  HomeInteractor.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

protocol HomeInteractor {
    func getNowPlayingMovies(page: Int) async throws -> [Movie]
    func getUpcomingMovies(page: Int) async throws -> [Movie]
    func getTopRatedMovies(page: Int) async throws -> [Movie]
    func getPopularMovies(page: Int) async throws -> [Movie]
    func getSingleMovie(id: Int) async throws -> SingleMovie
    func searchMovies(query: String) async throws -> [Movie]
    
    //MARK: LOGGING FUNCTIONS
    func trackEvent(eventName: String, parameters: [String: Any]?, type: LogType)
    func trackEvent(event: AnyLoggableEvent)
    func trackEvent(event: LoggableEvent)
    func trackScreenEvent(event: LoggableEvent)
}

extension CoreInteractor: HomeInteractor { }
