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
        
        do {
            isLoading = true
            let results = try await interactor.getNowPlayingMovies(page: page)
            nowPlayingMovies.append(contentsOf: results)
            isLoading = false
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func loadUpcomingMovies() async {
        
        do {
            let results = try await interactor.getUpcomingMovies(page: page)
            upcomingMovies.append(contentsOf: results)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func loadTopRatedMovies() async {
        
        do {
            let results = try await interactor.getTopRatedMovies(page: page)
            topRatedMovies.append(contentsOf: results)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func loadPopularMovies() async {
        
        do {
            let results = try await interactor.getPopularMovies(page: page)
            popularMovies.append(contentsOf: results)
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
    
    func loadMoreNowPlayingMovies(currentItem: Movie) async {
        guard nowPlayingMovies.last?.id == currentItem.id else {return}
        page += 1
        await loadNowPlayingMovies()
    }
    
    func loadMoreUpcomingMovies(currentItem: Movie) async {
        guard upcomingMovies.last?.id == currentItem.id else {return}
        page += 1
        await loadUpcomingMovies()
    }
    
    func loadMoreTopRatedMovies(currentItem: Movie) async {
        guard topRatedMovies.last?.id == currentItem.id else {return}
        page += 1
        await loadTopRatedMovies()
    }
    
    func loadMorePopularMovies(currentItem: Movie) async {
        guard popularMovies.last?.id == currentItem.id else {return}
        page += 1
        await loadPopularMovies()
    }
}
