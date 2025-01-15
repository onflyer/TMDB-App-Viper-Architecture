//
//  FavoritesPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 15. 1. 2025..
//

import Foundation

@Observable
class FavoritesPresenter {
    
    let interactor: FavoritesInteractor
    let router: FavoritesRouter
    
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    private(set) var favoriteMovies: [SingleMovie] = []
    
    @MainActor
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
