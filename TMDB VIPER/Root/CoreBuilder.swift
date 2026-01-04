//
//  CoreBuilder.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import SwiftUI
import UIKit

@MainActor
struct CoreBuilder {
    let interactor: CoreInteractor
    
    // MARK: - UIKit Builders (NEW)
    // These return UIViewController instead of SwiftUI Views
    
    /// Creates the HomeViewController for UIKit
    ///
    /// SwiftUI equivalent: homeView() -> some View
    func makeHomeViewController() -> UIViewController {
        // For now, we still use the SwiftUI router as placeholder
        // We'll update this when we create the UIKit router
        let presenter = HomePresenter(
            interactor: interactor,
            router: MockHomeRouter()
        )
        return HomeViewController(presenter: presenter)
    }
    
    /// Creates the DetailViewController for UIKit
    func makeDetailViewController(delegate: DetailViewDelegate = DetailViewDelegate()) -> UIViewController {
        let presenter = DetailPresenter(
            interactor: interactor,
            router: MockDetailRouter()
        )
        // TODO: Create DetailViewController
        return UIViewController() // Placeholder
    }
    
    // MARK: - SwiftUI Builders (EXISTING - keep for reference)
    // You can remove these once fully migrated to UIKit
    
    func homeView(delegate: HomeDelegate = HomeDelegate()) -> some View {
        RouterView { router in
            HomeView(
                presenter: HomePresenter(
                    interactor: interactor,
                    router: CoreRouter(router: router, builder: self)
                ),
                delegate: delegate
            )
        }
    }
    
    func detailView(router: Router, delegate: DetailViewDelegate = DetailViewDelegate()) -> some View {
        DetailView(
            presenter: DetailPresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            ),
            delegate: delegate
        )
    }
    
    func favoritesView(router: Router) -> some View {
        FavoritesView(
            presenter: FavoritesPresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            )
        )
    }
    
    func theatreLocationsView(router: Router) -> some View {
        TheatreLocationsView(
            presenter: TheatreLocationsPresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            )
        )
    }
    
    func trailerModalView(movie: SingleMovie, onDismiss: @escaping () -> Void) -> some View {
        let delegate = TrailersModalDelegate(movie: movie, onDismiss: onDismiss)
        return trailerModalView(delegate: delegate)
    }
    
    func trailerModalView(delegate: TrailersModalDelegate) -> some View {
        TrailersModalView(delegate: delegate)
    }
    
    func imageModalView(imageString: String, onDismiss: @escaping () -> Void) -> some View {
        let delegate = ImageModalViewDelegate(urlString: imageString, onDismiss: onDismiss)
        return imageModalView(delegate: delegate)
    }
    
    func imageModalView(delegate: ImageModalViewDelegate) -> some View {
        ImageModalView(delegate: delegate)
    }
}

// MARK: - Temporary Mock Routers
// These are placeholders until we build the real UIKit router

private struct MockHomeRouter: HomeRouter {
    func showDetailView(delegate: DetailViewDelegate) {
        print("MockHomeRouter: showDetailView called - implement UIKit navigation")
    }
}

private struct MockDetailRouter: DetailRouter {
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {
        print("MockDetailRouter: showTrailerModalView called")
    }
    
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {
        print("MockDetailRouter: showImageModalView called")
    }
    
    func showFavoritesView() {
        print("MockDetailRouter: showFavoritesView called")
    }
    
    func showTheatreLocationsView() {
        print("MockDetailRouter: showTheatreLocationsView called")
    }
    
    func dismissModal() {
        print("MockDetailRouter: dismissModal called")
    }
    
    func dismissScreen() {
        print("MockDetailRouter: dismissScreen called")
    }
}

// MARK: - Builder Pattern Explanation
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │                    BUILDER PATTERN                              │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   The Builder creates fully-configured view controllers.       │
 │   It hides the complexity of dependency injection.             │
 │                                                                 │
 │   WITHOUT Builder:                                              │
 │   ────────────────                                              │
 │   let networkService = NetworkService()                        │
 │   let movieManager = MovieManager(service: ...)                │
 │   let container = DependencyContainer()                        │
 │   container.register(...)                                      │
 │   let interactor = CoreInteractor(container: container)        │
 │   let router = CoreRouter(navigationController: navController) │
 │   let presenter = HomePresenter(interactor: interactor,        │
 │                                  router: router)               │
 │   let viewController = HomeViewController(presenter: presenter)│
 │                                                                 │
 │   WITH Builder:                                                 │
 │   ────────────                                                  │
 │   let viewController = builder.makeHomeViewController()        │
 │                                                                 │
 │   Much cleaner! 🎉                                              │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
