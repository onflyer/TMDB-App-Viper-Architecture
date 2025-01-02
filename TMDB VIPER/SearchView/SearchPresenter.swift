//
//  SearchPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 2. 1. 2025..
//

import Foundation

@Observable
class SearchPresenter {
    let interactor: SearchInteractor
    let router: SearchRouter
    
    var isSearching = false
    var query: String = ""
    
    private(set) var searchedMovies: [Movie] = []
    
    
    init(interactor: SearchInteractor, router: SearchRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadSerchedMovies() async {
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
        //    }
    }
}
