//
//  DetailViewTests.swift
//  TMDB VIPERTests
//
//  Created by Aleksandar Milidrag on 2. 2. 2025..
//

import Testing
import SwiftUI
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
    
    
    @Test("presenter happy path")
    func loadMovieSuccess() async {
        var events: [LoggableEvent] = []
        let movie = SingleMovie.mock()
        var favoriteMovies: [SingleMovie] = SingleMovie.mocks()
        
        let interactor = AnyDetailInteractor(
            getSingleMovie: { _ in movie },
            addToFavorites: { movie in
                favoriteMovies.append(movie)
            },
            removeFavorite: { movie in
                favoriteMovies.removeAll {  $0.id == 1 }
            },
            isFavorite: { movie in
                favoriteMovies.contains(where: {$0.id == 2 })
            },
            trackEvent: {event in
                events.append(event)
            },
            trackScreenEvent: { screenEvent in
                events.append(screenEvent)
            }
        )
        
        let presenter = DetailPresenter(interactor: interactor, router: MockDetailRouter())
        
        await presenter.loadSingleMovie(id: movie.id)
        presenter.addToFavorites()
        presenter.removeFromFavorites()
        presenter.checkIsFavorite()
        
        #expect(presenter.movie?.title == movie.title)
        #expect(favoriteMovies.contains(where: { movie in
            movie.id == movie.id
        }))
        #expect(!favoriteMovies.contains(where: { movie in
            movie.id == 1
        }))
        #expect(favoriteMovies.contains(where: {$0.id == 2}))
    }
    
    @Test("presenter failure path")
    func presenterFailurePath() async {
        var events: [LoggableEvent] = []
        let error: Error = URLError(.badServerResponse)

        
        
        let interactor = AnyDetailInteractor(
            getSingleMovie: { _ in
                throw error
            },
            addToFavorites: { movie in
                throw error
            },
            removeFavorite: { movie in
                throw error
            },
            isFavorite: { movie in
                throw error
            },
            trackEvent: { events.append($0) },
            trackScreenEvent: { events.append($0) }
        )
        
        let presenter = DetailPresenter(interactor: interactor, router: MockDetailRouter())
        
        await presenter.loadSingleMovie(id: 1)
        presenter.addToFavorites()
        presenter.removeFromFavorites()
        
        #expect(events.contains { $0.eventName == DetailPresenter.Event.loadSingleMovieFail(error: error).eventName })
        #expect(events.contains { $0.eventName == DetailPresenter.Event.addToFavoritesFail(error: error).eventName })
        #expect(events.contains { $0.eventName == DetailPresenter.Event.removeFromFavoritesFail(error: error).eventName })


        
    }
}
