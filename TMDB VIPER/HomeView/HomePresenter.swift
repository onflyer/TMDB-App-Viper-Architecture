//
//  HomePresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

// MARK: - HomePresenterDelegate
/// Protocol for presenter to communicate UI updates back to the view controller.
///
/// This is the KEY DIFFERENCE from SwiftUI:
/// - SwiftUI: @Observable automatically triggers body recomputation
/// - UIKit: Presenter calls these delegate methods, VC manually updates UI
@MainActor
protocol HomePresenterDelegate: AnyObject {
    func didLoadMovies(for section: HomeSection)
    func didFailToLoadMovies(with error: Error)
    func didStartLoading()
    func didFinishLoading()
    func didLoadSearchResults()
    func didFailToSearch(with error: Error)
}

@Observable
@MainActor
final class HomePresenter {
    
    // MARK: - Dependencies
    
    let interactor: HomeInteractor
    let router: HomeRouter
    
    // MARK: - Delegate
    
    /// Weak reference to avoid retain cycles.
    /// The ViewController owns the Presenter, so Presenter must NOT own ViewController.
    weak var delegate: HomePresenterDelegate?
    
    // MARK: - Pagination State (Separate counters per section)
    
    /// Each section has its own page counter to avoid pagination bugs.
    /// Previously, a single `page` variable was shared across all sections,
    /// causing incorrect page requests when scrolling different sections.
    private var nowPlayingPage: Int = 1
    private var upcomingPage: Int = 1
    private var topRatedPage: Int = 1
    private var popularPage: Int = 1
    
    // MARK: - Loading State
    
    private(set) var isLoading = false
    var query: String = ""
    
    // MARK: - Data
    
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []
    private(set) var popularMovies: [Movie] = []
    private(set) var searchedMovies: [Movie] = []
    
    // MARK: - Initialization
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Data Loading
    
    func loadNowPlayingMovies() async {
        interactor.trackEvent(event: Event.loadNowPlayingMoviesStart)
        do {
            let results = try await interactor.getNowPlayingMovies(page: nowPlayingPage)
            nowPlayingMovies.append(contentsOf: results)
            interactor.trackEvent(event: Event.loadNowPlayingMoviesSuccess(count: nowPlayingMovies.count))
            delegate?.didLoadMovies(for: .nowPlaying)
        } catch {
            interactor.trackEvent(event: Event.loadNowPlayingMoviesFail(error: error))
            delegate?.didFailToLoadMovies(with: error)
        }
    }
    
    func loadUpcomingMovies() async {
        do {
            let results = try await interactor.getUpcomingMovies(page: upcomingPage)
            upcomingMovies.append(contentsOf: results)
            interactor.trackEvent(event: Event.loadUpcomingMoviesSuccess(count: upcomingMovies.count))
            delegate?.didLoadMovies(for: .upcoming)
        } catch {
            interactor.trackEvent(event: Event.loadUpcomingMoviesFail(error: error))
            delegate?.didFailToLoadMovies(with: error)
        }
    }
    
    func loadTopRatedMovies() async {
        do {
            let results = try await interactor.getTopRatedMovies(page: topRatedPage)
            topRatedMovies.append(contentsOf: results)
            delegate?.didLoadMovies(for: .topRated)
        } catch {
            delegate?.didFailToLoadMovies(with: error)
        }
    }
    
    func loadPopularMovies() async {
        do {
            let results = try await interactor.getPopularMovies(page: popularPage)
            popularMovies.append(contentsOf: results)
            delegate?.didLoadMovies(for: .popular)
        } catch {
            delegate?.didFailToLoadMovies(with: error)
        }
    }
    
    /// Loads all movie sections concurrently.
    /// Called on initial load.
    func loadAllMovies() async {
        isLoading = true
        delegate?.didStartLoading()
        
        // Load all sections concurrently
        async let nowPlaying: () = loadNowPlayingMovies()
        async let upcoming: () = loadUpcomingMovies()
        async let topRated: () = loadTopRatedMovies()
        async let popular: () = loadPopularMovies()
        
        // Wait for all to complete
        _ = await (nowPlaying, upcoming, topRated, popular)
        
        isLoading = false
        delegate?.didFinishLoading()
    }
    
    // MARK: - Search
    
    func loadSearchedMovies(query: String) async {
        guard !query.isEmpty else {
            searchedMovies.removeAll()
            delegate?.didLoadSearchResults()
            return
        }
        
        do {
            searchedMovies = try await interactor.searchMovies(query: query)
            delegate?.didLoadSearchResults()
        } catch {
            delegate?.didFailToSearch(with: error)
        }
    }
    
    // MARK: - Navigation
    
    func onMoviePressed(id: Int) {
        let delegate = DetailViewDelegate(movieId: id)
        router.showDetailView(delegate: delegate)
    }
    
    // MARK: - Pagination
    
    func loadMoreNowPlayingMovies(currentItem: Movie) async {
        guard nowPlayingMovies.last?.id == currentItem.id else { return }
        nowPlayingPage += 1
        await loadNowPlayingMovies()
    }
    
    func loadMoreUpcomingMovies(currentItem: Movie) async {
        guard upcomingMovies.last?.id == currentItem.id else { return }
        upcomingPage += 1
        await loadUpcomingMovies()
    }
    
    func loadMoreTopRatedMovies(currentItem: Movie) async {
        guard topRatedMovies.last?.id == currentItem.id else { return }
        topRatedPage += 1
        await loadTopRatedMovies()
    }
    
    func loadMorePopularMovies(currentItem: Movie) async {
        guard popularMovies.last?.id == currentItem.id else { return }
        popularPage += 1
        await loadPopularMovies()
    }
}

// MARK: - Logging

extension HomePresenter {
    
    func onViewAppear(delegate: HomeDelegate) {
        interactor.trackScreenView(event: Event.onAppear(delegate: delegate))
    }
    
    func onViewDisappear(delegate: HomeDelegate) {
        interactor.trackEvent(event: Event.onDisappear(delegate: delegate))
    }
    
    enum Event: LoggableEvent {
        case onAppear(delegate: HomeDelegate)
        case onDisappear(delegate: HomeDelegate)
        case loadNowPlayingMoviesStart
        case loadNowPlayingMoviesSuccess(count: Int)
        case loadNowPlayingMoviesFail(error: Error)
        case loadUpcomingMoviesStart
        case loadUpcomingMoviesSuccess(count: Int)
        case loadUpcomingMoviesFail(error: Error)

        var eventName: String {
            switch self {
            case .onAppear:                         return "HomeView_Appeared"
            case .onDisappear:                      return "HomeView_Disappeared"
            case .loadNowPlayingMoviesStart:        return "HomeView_LoadNowPlayingMovies_Start"
            case .loadNowPlayingMoviesSuccess:      return "HomeView_LoadNowPlayingMovies_Success"
            case .loadNowPlayingMoviesFail:         return "HomeView_LoadNowPlayingMovies_Fail"
            case .loadUpcomingMoviesStart:          return "HomeView_LoadUpcomingMovies_Start"
            case .loadUpcomingMoviesSuccess:        return "HomeView_LoadUpcomingMovies_Success"
            case .loadUpcomingMoviesFail:           return "HomeView_LoadUpcomingMovies_Fail"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate), .onDisappear(delegate: let delegate):
                return delegate.eventParameters
                
            case .loadNowPlayingMoviesSuccess(count: let count), .loadUpcomingMoviesSuccess(count: let count):
                return [
                    "now_playing_movies_count": count,
                    "upcoming_movies_count": count
                ]
            case .loadNowPlayingMoviesFail(error: let error), .loadUpcomingMoviesFail(error: let error):
                return error.eventParameters
            default:
                return nil
            }
        }
        
        var type: LogType {
            switch self {
            case .loadNowPlayingMoviesFail:
                return .severe
            default:
                return .info
            }
        }
    }
}
