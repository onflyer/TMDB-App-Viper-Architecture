//
//  HomeViewTests.swift
//  TMDB VIPERTests
//
//  Created by Aleksandar Milidrag on 27. 1. 2025..
//

import Testing
import SwiftUI
@testable import TMDB_VIPER

@MainActor
struct HomePresenterTests {
    
    @MainActor
    struct MockHomeRouter: HomeRouter {
        
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
        
        func trackScreenView(event: any TMDB_VIPER.LoggableEvent) {
            anyTrackScreenEvent(event)
        }
        
    }
    
    //MARK: TYPE ERASED INTERACTOR
    @Test("load Movies Success")
    func loadMoviesSuccess() async throws {
        var events: [LoggableEvent] = []
        let movies = Movie.mocks()
        let movie = SingleMovie.mock()
        
        let interactor = AnyHomeInteractor(
            getMovies: { _ in movies},
            getSingleMovie: { _ in movie },
            searchMovies: { _ in movies },
            trackEvent: { events.append($0) },
            trackScreenEvent: { events.append($0) }
        )
        let presenter = HomePresenter(interactor: interactor, router: MockHomeRouter())
        
        await presenter.loadNowPlayingMovies()
        await presenter.loadUpcomingMovies()
        await presenter.loadTopRatedMovies()
        await presenter.loadPopularMovies()
        await presenter.loadSearchedMovies(query: "Mock")
        
        #expect(presenter.nowPlayingMovies == movies)
        #expect(presenter.upcomingMovies == movies)
        #expect(presenter.topRatedMovies == movies)
        #expect(presenter.popularMovies == movies)
        #expect(presenter.searchedMovies.count == movies.count)
        #expect(presenter.isLoading == false)
        #expect(events.contains { $0.eventName == HomePresenter.Event.loadNowPlayingMoviesSuccess(count: 0).eventName })
        
    }
    
    @Test("load Movies Failure")
    func loadMoviesFailure() async throws {
        let error: Error = URLError(.badURL)
        var events: [LoggableEvent] = []
        
        let interactor = AnyHomeInteractor(
            getMovies: { _ in
                throw error
            },
            getSingleMovie: { _ in
                throw error
            },
            searchMovies: { _ in
                throw error
            },
            trackEvent: { events.append($0) },
            trackScreenEvent: { events.append($0) }
        )
        
        let presenter = HomePresenter(interactor: interactor, router: MockHomeRouter())
        
        await presenter.loadNowPlayingMovies()
        await presenter.loadUpcomingMovies()
        
        #expect(events.contains { $0.eventName == HomePresenter.Event.loadNowPlayingMoviesFail(error: error).eventName })
        #expect(events.contains { $0.eventName == HomePresenter.Event.loadUpcomingMoviesFail(error: error).eventName })
        
    }
    
    
}
