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
    
    struct AnyHomeInteractor: HomeInteractor {
        let anyGetMovies: (Int) async throws -> [Movie]
        let anyGetSingleMovie: (Int) async throws -> [SingleMovie]
        let anySearchMovies: (String) async throws -> [Movie]
        let anyTrackEvent: (LoggableEvent) -> Void
        let anyTrackScreenEvent: (LoggableEvent) -> Void
        
        
        
        
        func getNowPlayingMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            <#code#>
        }
        
        func getUpcomingMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            <#code#>
        }
        
        func getTopRatedMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            <#code#>
        }
        
        func getPopularMovies(page: Int) async throws -> [TMDB_VIPER.Movie] {
            <#code#>
        }
        
        func getSingleMovie(id: Int) async throws -> TMDB_VIPER.SingleMovie {
            <#code#>
        }
        
        func searchMovies(query: String) async throws -> [TMDB_VIPER.Movie] {
            <#code#>
        }
        
        func trackEvent(event: any TMDB_VIPER.LoggableEvent) {
            <#code#>
        }
        
        func trackScreenEvent(event: any TMDB_VIPER.LoggableEvent) {
            <#code#>
        }
        
        
    }
}
