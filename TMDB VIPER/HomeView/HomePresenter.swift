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
    var isSearching = false
    var query: String = ""
    
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []
    private(set) var popularMovies: [Movie] = []
    private(set) var searchedMovies: [Movie] = []
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    @MainActor
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
    
    @MainActor
    func loadUpcomingMovies() async {
        guard upcomingMovies.isEmpty else { return }
        
        do {
            upcomingMovies = try await interactor.getUpcomingMovies(page: page)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func loadTopRatedMovies() async {
        guard topRatedMovies.isEmpty else { return }
        
        do {
            topRatedMovies = try await interactor.getTopRatedMovies(page: page)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func loadPopularMovies() async {
        guard topRatedMovies.isEmpty else { return }
        
        do {
            popularMovies = try await interactor.getPopularMovies(page: page)
        } catch {
            print(error)
        }
    }
    
    func loadSearchedMovies() async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            searchedMovies.removeAll()
            return
        }
        
        do {
            searchedMovies = try await interactor.searchMovies(query: trimmedQuery)
        } catch {
            print(error)
        }
    }
    
    func onMoviePressed(id: Int) {
        let delegate = DetailViewDelegate(movieId: id)
        router.showDetailView(delegate: delegate)
    }
}
