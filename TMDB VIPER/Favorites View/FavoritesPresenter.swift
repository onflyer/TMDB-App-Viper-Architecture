//
//  FavoritesPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 15. 1. 2025..
//

import SwiftUI

@MainActor
@Observable
class FavoritesPresenter {
    
    let interactor: FavoritesInteractor
    let router: FavoritesRouter
    
    private(set) var favoriteMovies: [SingleMovie] = []
    
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadFavorites() {
        do {
            favoriteMovies = try interactor.getFavorites()
        } catch {
            print(error)
        }
    }
    
    func removeFavorite(movie: SingleMovie) {
        do {
            try interactor.removeFavorite(movie: movie)
        } catch {
            print(error)
        }
    }
    
    func onMoviePressed(id: Int) {
        let delegate = DetailViewDelegate(movieId: id)
        router.showDetailView(delegate: delegate)
    }
    
    func removeFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            let movie = favoriteMovies[index]
            removeFavorite(movie: movie)
        }
    }

}
