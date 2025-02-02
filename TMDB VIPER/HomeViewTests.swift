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
struct HomeViewTests {

    @MainActor
    class MockHomeRouter: HomeRouter {
        
        
        func showDetailView(delegate: DetailViewDelegate) {
            
        }
    }
    
    @MainActor
    struct MockHomeInteractor: HomeInteractor {
       
        var mockLogService = MockLogService()
        var events: [LoggableEvent] = []
        var movies = Movie.mocks()
        var movie = SingleMovie.mock()
        
    
        func getNowPlayingMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            movies
        }
        
        func getUpcomingMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            movies
        }
        
        func getTopRatedMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            movies
        }
        
        func getPopularMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            movies
        }
        
        func getSingleMovie(id: Int) async throws -> TMDB_VIPER.SingleMovie {
            movie
        }
        
        func searchMovies(query: String) async throws -> [TMDB_VIPER.Movie] {
            return try movies.filter(#Predicate { movie in
                movie.title?.localizedStandardContains(query) ?? false
            })
        }
        
        func trackEvent(event: any TMDB_VIPER.LoggableEvent) {
            mockLogService.trackEvent(event: event)
        }
        
        func trackScreenView(event: any TMDB_VIPER.LoggableEvent) {
            mockLogService.trackScreenView(event: event)
        }
    }
    
    @Test("load Movies Success 1")
    func loadMoviesSuccess1() async throws {
        
        let query = "Mock Movie"
        let router = MockHomeRouter()
        let interactor = MockHomeInteractor()
        let presenter = HomePresenter(interactor: interactor, router: router)
        
        
        await presenter.loadNowPlayingMovies()
        await presenter.loadUpcomingMovies()
        await presenter.loadTopRatedMovies()
        await presenter.loadPopularMovies()
        await presenter.loadSearchedMovies(query: query)
        
        
        
        #expect(presenter.nowPlayingMovies == interactor.movies)
        #expect(presenter.upcomingMovies == interactor.movies)
        #expect(presenter.topRatedMovies == interactor.movies)
        #expect(presenter.popularMovies == interactor.movies)
        #expect(presenter.searchedMovies.count == interactor.movies.count)
        #expect(interactor.mockLogService.trackedEvents.contains(where: {
            $0.eventName == HomePresenter.Event.loadNowPlayingMoviesSuccess(count: 0).eventName
        }))
    }
    
    

}
