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
    var isLoading = false
    
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []
    private(set) var popularMovies: [Movie] = []
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadNowPlayingMovies() async {
        guard nowPlayingMovies.isEmpty else { return }
        
        do {
            isLoading = true
            nowPlayingMovies = try await interactor.getNowPlayingMovies(page: page)
            isLoading = false
        } catch {
            print(error)
        }
    }
    
    func loadUpcomingMovies() async {
        guard upcomingMovies.isEmpty else { return }
        
        do {
            upcomingMovies = try await interactor.getUpcomingMovies(page: page)
        } catch {
            print(error)
        }
    }
    
    func loadTopRatedMovies() async {
        guard topRatedMovies.isEmpty else { return }
        
        do {
            topRatedMovies = try await interactor.getTopRatedMovies(page: page)
        } catch {
            print(error)
        }
    }
    
    func loadPopularMovies() async {
        guard topRatedMovies.isEmpty else { return }
        
        do {
            popularMovies = try await interactor.getPopularMovies(page: page)
        } catch {
            print(error)
        }
    }
    
    func onMoviePressed(movie: Movie) {
        
    }
}
