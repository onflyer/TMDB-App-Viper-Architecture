//
//  HomePresenter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import Foundation

@Observable
@MainActor
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
    
    func loadNowPlayingMovies() async {
        interactor.trackEvent(event: Event.loadNowPlayingMoviesStart)
        do {
            isLoading = true
            let results = try await interactor.getNowPlayingMovies(page: page)
            isLoading = false
            nowPlayingMovies.append(contentsOf: results)
            interactor.trackEvent(event: Event.loadNowPlayingMoviesSuccess(count: nowPlayingMovies.count))
        } catch {
            interactor.trackEvent(event: Event.loadNowPlayingMoviesFail(error: error))
        }
    }
    
    func loadUpcomingMovies() async {
        
        do {
            let results = try await interactor.getUpcomingMovies(page: page)
            upcomingMovies.append(contentsOf: results)
        } catch {
            interactor.trackEvent(event: Event.loadUpcomingMoviesFail(error: error))
        }
    }
    
    func loadTopRatedMovies() async {
        
        do {
            let results = try await interactor.getTopRatedMovies(page: page)
            topRatedMovies.append(contentsOf: results)
        } catch {
            print(error)
        }
    }
    
    func loadPopularMovies() async {
        
        do {
            let results = try await interactor.getPopularMovies(page: page)
            popularMovies.append(contentsOf: results)
        } catch {
            print(error)
        }
    }
    
    func loadSearchedMovies(query: String) async {
        
        guard !query.isEmpty else {
            searchedMovies.removeAll()
            return
        }
            
        do {
            searchedMovies = try await interactor.searchMovies(query: query)
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

extension HomePresenter {
    
    //MARK: LOGGING FUNCTIONS
    
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
            case .onAppear:                                             return "HomeView_Appeared"
            case .onDisappear:                                          return "HomeView_Disappeared"
            case .loadNowPlayingMoviesStart:                            return "HomeView_LoadNowPlayingMovies_Start"
            case .loadNowPlayingMoviesSuccess:                          return "HomeView_LoadNowPlayingMovies_Success"
            case .loadNowPlayingMoviesFail:                             return "HomeView_LoadNowPlayingMovies_Fail"
            case .loadUpcomingMoviesStart:                              return "HomeView_LoadUpcomingMovies_Start"
            case .loadUpcomingMoviesSuccess:                            return "HomeView_LoadUpcomingMovies_Success"
            case .loadUpcomingMoviesFail:                               return "HomeView_LoadUpcomingMovies_Fail"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate), .onDisappear(delegate: let delegate):
                return delegate.eventParameters
                
            case .loadNowPlayingMoviesSuccess(count: let count), .loadUpcomingMoviesSuccess(count: let count):
                return [ "now_playing_movies_count": count,
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
