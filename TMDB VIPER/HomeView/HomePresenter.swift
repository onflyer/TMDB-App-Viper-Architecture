//
//  HomePresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

@Observable
class HomePresenter {
    
    let interactor: HomeInteractor
    let router: HomeRouter
    var page: Int = 1
    
    private(set) var nowPlayingMovies: [Movie] = []
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadNowPlayingMovies() async {
        guard nowPlayingMovies.isEmpty else { return }
        
        do {
            nowPlayingMovies = try await interactor.getNowPlayingMovies(page: page)
        } catch {
            print(error)
        }
    }
}
