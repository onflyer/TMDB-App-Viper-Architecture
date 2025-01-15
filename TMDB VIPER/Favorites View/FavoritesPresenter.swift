//
//  FavoritesPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 15. 1. 2025..
//

import SwiftUI

@Observable
@MainActor
class FavoritesPresenter {
    
    let interactor: FavoritesInteractor
    let router: FavoritesRouter
    
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
//        loadFavorites()
//        print(favoriteMovies)
    }
    
    private(set) var favoriteMovies: [SingleMovie] = []
    
    func loadFavorites() {
        do {
            favoriteMovies = try interactor.getFavorites()
        } catch {
            print(error)
        }
    }
    
    func onMoviePressed(id: Int) {
        let delegate = DetailViewDelegate(movieId: id)
        router.showDetailView(delegate: delegate)
    }

}
