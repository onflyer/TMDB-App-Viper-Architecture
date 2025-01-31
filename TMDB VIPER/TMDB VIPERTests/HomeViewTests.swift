//
//  HomeViewTests.swift
//  TMDB VIPERTests
//
//  Created by Aleksandar Milidrag on 27. 1. 2025..
//

import Testing
@testable import TMDB_VIPER

@MainActor
struct HomeViewTests {

    @MainActor
    class MockHomeRouter: HomeRouter {
        
        
        func showDetailView(delegate: DetailViewDelegate) {
            
        }
    }
    
    @MainActor
    struct AnyHomeInteractor: HomeInteractor {
        let anyGetMovies: (Int) async throws -> [Movie]
        let anyGetSingleMovie: (Int) async throws -> SingleMovie
        let anySearchMovies: (String) async throws -> [Movie]
        let anyTrackEvent: (LoggableEvent) -> Void
        let anyTrackScreenEvent: (LoggableEvent) -> Void
        
        init(
             getMovies: @escaping (Int) async throws -> [Movie],
             getSingleMovie: @escaping (Int) async throws -> SingleMovie,
             searchMovies: @escaping (String) async throws -> [Movie],
             trackEvent: @escaping (LoggableEvent) -> Void,
             trackScreenEvent: @escaping (LoggableEvent) -> Void
        ) {
            self.anyGetMovies = getMovies
            self.anyGetSingleMovie = getSingleMovie
            self.anySearchMovies = searchMovies
            self.anyTrackEvent = trackEvent
            self.anyTrackScreenEvent = trackScreenEvent
        }
        
        
        func getNowPlayingMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            try await anyGetMovies(page)
        }
        
        func getUpcomingMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            try await anyGetMovies(page)
        }
        
        func getTopRatedMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            try await anyGetMovies(page)
        }
        
        func getPopularMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            try await anyGetMovies(page)
        }
        
        func getSingleMovie(id: Int) async throws -> TMDB_VIPER.SingleMovie {
            try await anyGetSingleMovie(id)

        }
        
        func searchMovies(query: String) async throws -> [TMDB_VIPER.Movie] {
            try await anySearchMovies(query)
        }
        
        func trackEvent(event: any TMDB_VIPER.LoggableEvent) {
            anyTrackEvent(event)
        }
        
        func trackScreenEvent(event: any TMDB_VIPER.LoggableEvent) {
            anyTrackScreenEvent(event)
        }
        
        
        @Test("loadMoviesSuccess")
        func loadMoviesSuccess() async throws {
            var events: [LoggableEvent] = []
            let movies = Movie.mocks()
            let movie = SingleMovie.mock()
            
            let interactor = AnyHomeInteractor(
                        getMovies: { _ in movies },
                        getSingleMovie: { _ in movie },
                        searchMovies: { _ in movies },
                        trackEvent: { events.append($0) },
                        trackScreenEvent: { events.append($0) }
                    )

        }
        
    }
}
