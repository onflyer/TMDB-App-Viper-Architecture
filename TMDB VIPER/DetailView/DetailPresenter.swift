//
//  DetailPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

@Observable
@MainActor
class DetailPresenter {
    let interactor: DetailInteractor
    let router: DetailRouter
    
    var movie: SingleMovie? = nil
    
    init(interactor: DetailInteractor, router: DetailRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadSingleMovie(id: Int) async {
        do {
            movie = try await interactor.getSingleMovie(id: id)
        } catch {
            print(error)
        }
    }
    
    func onWatchTrailerPressed() {
        guard let movie else { return }
        router.showTrailerModalView(movie: movie) {
            self.router.dismissModal()
        }
    }
    
    func onFavoritesPressed() {
        router.showFavoritesView()
    }
    
    func addToFavorites() {
        guard let movie else { return }
        do {
            try interactor.addToFavorites(movie: movie)
        } catch {
            print(error)
        }
    }
    
}
