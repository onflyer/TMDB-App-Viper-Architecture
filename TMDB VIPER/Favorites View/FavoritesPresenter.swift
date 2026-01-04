//
//  FavoritesPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 15. 1. 2025..
//

import SwiftUI

// MARK: - FavoritesPresenterDelegate
/// Protocol for presenter to communicate UI updates back to the view controller.
@MainActor
protocol FavoritesPresenterDelegate: AnyObject {
    func didLoadFavorites()
    func didFailToLoadFavorites(with error: Error)
    func didRemoveFavorite(at index: Int)
    func didFailToRemoveFavorite(with error: Error)
}

@MainActor
@Observable
final class FavoritesPresenter {
    
    // MARK: - Dependencies
    
    let interactor: FavoritesInteractor
    let router: FavoritesRouter
    
    // MARK: - Delegate
    
    weak var delegate: FavoritesPresenterDelegate?
    
    // MARK: - State
    
    private(set) var favoriteMovies: [SingleMovie] = []
    
    // MARK: - Initialization
    
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Data Loading
    
    func loadFavorites() {
        do {
            favoriteMovies = try interactor.getFavorites()
            delegate?.didLoadFavorites()
        } catch {
            delegate?.didFailToLoadFavorites(with: error)
        }
    }
    
    // MARK: - Favorites Management
    
    func removeFavorite(movie: SingleMovie) {
        do {
            try interactor.removeFavorite(movie: movie)
        } catch {
            delegate?.didFailToRemoveFavorite(with: error)
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            let movie = favoriteMovies[index]
            removeFavorite(movie: movie)
            delegate?.didRemoveFavorite(at: index)
        }
    }
    
    // MARK: - Navigation
    
    func onMoviePressed(id: Int) {
        let delegate = DetailViewDelegate(movieId: id)
        router.showDetailView(delegate: delegate)
    }
}
