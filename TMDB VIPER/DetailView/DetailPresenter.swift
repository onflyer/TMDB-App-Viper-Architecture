//
//  DetailPresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 23. 12. 2024..
//

import SwiftUI

// MARK: - DetailPresenterDelegate
/// Protocol for presenter to communicate UI updates back to the view controller.
@MainActor
protocol DetailPresenterDelegate: AnyObject {
    func didLoadMovie()
    func didFailToLoadMovie(with error: Error)
    func didUpdateFavoriteStatus()
    func didFailToUpdateFavorite(with error: Error)
}

@MainActor
@Observable
final class DetailPresenter {
    
    // MARK: - Dependencies
    
    let interactor: DetailInteractor
    let router: DetailRouter
    
    // MARK: - Delegate
    
    weak var delegate: DetailPresenterDelegate?
    
    // MARK: - State
    
    var movie: SingleMovie? = nil
    var isFavorite: Bool = false
    var isLoading: Bool = false
    
    // MARK: - Initialization
    
    init(interactor: DetailInteractor, router: DetailRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Data Loading
    
    func loadSingleMovie(id: Int) async {
        interactor.trackEvent(event: Event.loadSingleMovieStart)
        isLoading = true
        
        do {
            movie = try await interactor.getSingleMovie(id: id)
            checkIsFavorite()
            interactor.trackEvent(event: Event.loadSingleMovieSuccess(isMovieLoaded: (movie != nil)))
            delegate?.didLoadMovie()
        } catch {
            interactor.trackEvent(event: Event.loadSingleMovieFail(error: error))
            delegate?.didFailToLoadMovie(with: error)
        }
        
        isLoading = false
    }
    
    // MARK: - Navigation
    
    func onWatchTrailerPressed() {
        guard let movie else { return }
        // IMPORTANT: Use [weak self] to prevent retain cycles
        router.showTrailerModalView(movie: movie) { [weak self] in
            self?.router.dismissModal()
        }
    }
    
    func onMovieImagePressed() {
        guard let movie else { return }
        // IMPORTANT: Use [weak self] to prevent retain cycles
        router.showImageModalView(urlString: movie.posterURLString ?? "No image") { [weak self] in
            self?.router.dismissModal()
        }
    }
    
    func onFavoritesPressed() {
        router.showFavoritesView()
    }
    
    func onLocalTheatersPressed() {
        router.showTheatreLocationsView()
    }
    
    // MARK: - Favorites Management
    
    func addToFavorites() {
        interactor.trackEvent(event: Event.addToFavoritesStart)
        guard let movie else { return }
        
        do {
            try interactor.addToFavorites(movie: movie)
            interactor.trackEvent(event: Event.addToFavoritesSuccess)
            delegate?.didUpdateFavoriteStatus()
        } catch {
            interactor.trackEvent(event: Event.addToFavoritesFail(error: error))
            delegate?.didFailToUpdateFavorite(with: error)
        }
    }
    
    func removeFromFavorites() {
        interactor.trackEvent(event: Event.removeFromFavoritesStart)
        guard let movie else { return }
        
        do {
            try interactor.removeFavorite(movie: movie)
            interactor.trackEvent(event: Event.removeFromFavoritesSuccess)
            delegate?.didUpdateFavoriteStatus()
        } catch {
            interactor.trackEvent(event: Event.removeFromFavoritesFail(error: error))
            delegate?.didFailToUpdateFavorite(with: error)
        }
    }
    
    func checkIsFavorite() {
        interactor.trackEvent(event: Event.checkIsFavoriteStart)
        guard let movie else { return }
        
        do {
            isFavorite = try interactor.isFavorite(movie: movie)
            interactor.trackEvent(event: Event.checkIsFavoriteSuccess)
        } catch {
            interactor.trackEvent(event: Event.checkIsFavoriteFail(error: error))
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

// MARK: - Logging

extension DetailPresenter {
    
    func onViewAppear(delegate: DetailViewDelegate) {
        interactor.trackScreenView(event: Event.onAppear(delegate: delegate))
    }
    
    func onViewDisappear(delegate: DetailViewDelegate) {
        interactor.trackEvent(event: Event.onDisappear(delegate: delegate))
    }
    
    enum Event: LoggableEvent {
        case onAppear(delegate: DetailViewDelegate)
        case onDisappear(delegate: DetailViewDelegate)
        case loadSingleMovieStart
        case loadSingleMovieSuccess(isMovieLoaded: Bool)
        case loadSingleMovieFail(error: Error)
        case addToFavoritesStart
        case addToFavoritesSuccess
        case addToFavoritesFail(error: Error)
        case removeFromFavoritesStart
        case removeFromFavoritesSuccess
        case removeFromFavoritesFail(error: Error)
        case checkIsFavoriteStart
        case checkIsFavoriteSuccess
        case checkIsFavoriteFail(error: Error)

        var eventName: String {
            switch self {
            case .onAppear:                     return "DetailView_Appeared"
            case .onDisappear:                  return "DetailView_Disappeared"
            case .loadSingleMovieStart:         return "DetailView_LoadSingleMovie_Start"
            case .loadSingleMovieSuccess:       return "DetailView_LoadSingleMovie_Success"
            case .loadSingleMovieFail:          return "DetailView_LoadSingleMovie_Fail"
            case .addToFavoritesStart:          return "DetailView_AddToFavorites_Start"
            case .addToFavoritesSuccess:        return "DetailView_AddToFavorites_Success"
            case .addToFavoritesFail:           return "DetailView_AddToFavorites_Fail"
            case .removeFromFavoritesStart:     return "DetailView_RemoveFromFavorites_Start"
            case .removeFromFavoritesSuccess:   return "DetailView_RemoveFromFavorites_Success"
            case .removeFromFavoritesFail:      return "DetailView_RemoveFromFavorites_Fail"
            case .checkIsFavoriteStart:         return "DetailView_CheckIsFavorite_Start"
            case .checkIsFavoriteSuccess:       return "DetailView_CheckIsFavorite_Success"
            case .checkIsFavoriteFail:          return "DetailView_CheckIsFavorite_Fail"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate), .onDisappear(delegate: let delegate):
                return delegate.eventParameters
                
            case .loadSingleMovieSuccess(isMovieLoaded: let isMovieLoaded):
                return [
                    "single_movie_isMovieLoaded": isMovieLoaded.description,
                ]
            case .loadSingleMovieFail(error: let error),
                 .addToFavoritesFail(error: let error),
                 .removeFromFavoritesFail(error: let error),
                 .checkIsFavoriteFail(error: let error):
                return error.eventParameters
            default:
                return nil
            }
        }
        
        var type: LogType {
            switch self {
            case .loadSingleMovieFail, .addToFavoritesFail, .removeFromFavoritesFail:
                return .severe
            default:
                return .info
            }
        }
    }
}
