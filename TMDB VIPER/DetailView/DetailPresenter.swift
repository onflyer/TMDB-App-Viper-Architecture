//
//  DetailPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

@MainActor
@Observable
class DetailPresenter {
    let interactor: DetailInteractor
    let router: DetailRouter
    
    var movie: SingleMovie? = nil
    var isFavorite: Bool = false
    var isLoading: Bool = false
    
    init(interactor: DetailInteractor, router: DetailRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadSingleMovie(id: Int) async {
        isLoading = true
        do {
            movie = try await interactor.getSingleMovie(id: id)
            checkIsFavorite()
        } catch {
            print(error)
        }
        isLoading = false

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
    
    func removeFromFavorites() {
        guard let movie else { return }
        do {
            try interactor.removeFavorite(movie: movie)
        } catch {
            print(error)
        }
    }
    
    func checkIsFavorite() {
        guard let movie else { return }
        do {
            isFavorite = try interactor.isFavorite(movie: movie)
        } catch {
            print(error)
        }
    }
    
    func onHeartPressed() {
        if !isFavorite {
            addToFavorites()
            isFavorite = true
        } else {
            removeFromFavorites()
            isFavorite = false
        }
    }

}

extension DetailPresenter {
    
    //MARK: LOGGING FUNCTIONS
    
    func onViewAppear(delegate: DetailViewDelegate) {
        interactor.trackScreenEvent(event: Event.onAppear(delegate: delegate))
    }
    
    func onViewDisappear(delegate: DetailViewDelegate) {
        interactor.trackEvent(event: Event.onDisappear(delegate: delegate))
    }
    
    
    enum Event: LoggableEvent {
        case onAppear(delegate: DetailViewDelegate)
        case onDisappear(delegate: DetailViewDelegate)

        var eventName: String {
            switch self {
            case .onAppear:                 return "DetailView_Appeared"
            case .onDisappear:              return "DetailView_Disappeared"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate), .onDisappear(delegate: let delegate):
                return delegate.eventParameters
//            default:
//                return nil
            }
        }
        
        var type: LogType {
            switch self {
            default:
                return .info
            }
        }
    }
}
