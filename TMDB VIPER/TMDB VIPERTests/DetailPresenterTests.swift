//
//  DetailViewTests.swift
//  TMDB VIPERTests
//
//  Created by Aleksandar Milidrag on 2. 2. 2025..
//

import Testing
@testable import TMDB_VIPER

@MainActor
struct DetailPresenterTests {

    @MainActor
    struct MockDetailRouter: DetailRouter {
        
        func showTrailerModalView(movie: TMDB_VIPER.SingleMovie, onXMarkPressed: @escaping () -> Void) {
            
        }
        
        func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {
            
        }
        
        func showFavoritesView() {
            
        }
        
        func dismissModal() {
            
        }
        
        func dismissScreen() {
            
        }
        
        
    }
    
    @MainActor
    struct AnyDetailInteractor: DetailInteractor {
        
        let anyGetSingleMovie: (Int) async throws -> SingleMovie
        let anyAddToFavorites: (SingleMovie) throws -> Void
        let anyRemoveFavorite: (SingleMovie) throws -> Void
        let anyIsFavorite: (SingleMovie) throws -> Bool
        let anyTrackEvent: (LoggableEvent) -> Void
        let anyTrackScreenEvent: (LoggableEvent) -> Void
        
        init(
            getSingleMovie: @escaping (Int) async throws -> SingleMovie,
            addToFavorites: @escaping (SingleMovie) throws -> Void,
            removeFavorite: @escaping (SingleMovie) throws -> Void,
            isFavorite: @escaping (SingleMovie) throws -> Bool,
            trackEvent: @escaping (LoggableEvent) -> Void,
            trackScreenEvent: @escaping (LoggableEvent) -> Void
        ) {
            self.anyGetSingleMovie = getSingleMovie
            self.anyAddToFavorites = addToFavorites
            self.anyRemoveFavorite = removeFavorite
            self.anyIsFavorite = isFavorite
            self.anyTrackEvent = trackEvent
            self.anyTrackScreenEvent = trackScreenEvent
        }
        
        func getSingleMovie(id: Int) async throws -> TMDB_VIPER.SingleMovie {
            try await anyGetSingleMovie(id)
        }
        
        func addToFavorites(movie: TMDB_VIPER.SingleMovie) throws {
            try anyAddToFavorites(movie)
        }
        
        func removeFavorite(movie: TMDB_VIPER.SingleMovie) throws {
            try anyRemoveFavorite(movie)
        }
        
        func isFavorite(movie: TMDB_VIPER.SingleMovie) throws -> Bool {
            try anyIsFavorite(movie)
        }
        
        func trackEvent(event: any TMDB_VIPER.LoggableEvent) {
            anyTrackEvent(event)
        }
        
        func trackScreenView(event: any TMDB_VIPER.LoggableEvent) {
            anyTrackScreenEvent(event)
        }
    }
    
    
    @Test("Load Movie Success")
    func loadMovieSuccess() async {
        var events: [LoggableEvent] = []
        let movie = SingleMovie.mock()
        
        let interactor = AnyDetailInteractor(
            getSingleMovie: { _ in movie },
            addToFavorites: { movie in },
            removeFavorite: { movie in },
            isFavorite: { movie in true },
            trackEvent: {event in
                events.append(event)
            },
            trackScreenEvent: { screenEvent in
                events.append(screenEvent)
            }
        )
        
        let presenter = DetailPresenter(interactor: interactor, router: MockDetailRouter())
        
        await presenter.loadSingleMovie(id: movie.id)
    }
}
