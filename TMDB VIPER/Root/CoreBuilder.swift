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
    
    // MARK: - UIKit Builders
    // These return UIViewController for UIKit navigation
    
    /// Creates HomeViewController with a proper router.
    /// The ViewController wires up its presenter's delegate internally.
    func makeHomeViewController(router: UIKitRouter) -> UIViewController {
        let presenter = HomePresenter(
            interactor: interactor,
            router: router
        )
        // HomeViewController sets presenter.delegate = self in its init
        return HomeViewController(presenter: presenter)
    }
    
    /// Creates the DetailViewController for showing movie details.
    /// The ViewController wires up its presenter's delegate internally.
    func makeDetailViewController(
        delegate: DetailViewDelegate = DetailViewDelegate(),
        router: UIKitRouter
    ) -> UIViewController {
        let presenter = DetailPresenter(
            interactor: interactor,
            router: router
        )
        // DetailViewController sets presenter.delegate = self in its init
        return DetailViewController(presenter: presenter, delegate: delegate)
    }
    
    /// Creates the FavoritesViewController for showing saved movies.
    /// The ViewController wires up its presenter's delegate internally.
    func makeFavoritesViewController(router: UIKitRouter) -> UIViewController {
        let presenter = FavoritesPresenter(
            interactor: interactor,
            router: router
        )
        // FavoritesViewController sets presenter.delegate = self in its init
        return FavoritesViewController(presenter: presenter)
    }
    
    /// Creates the TheatreLocationsViewController for showing nearby theaters.
    func makeTheatreLocationsViewController(router: UIKitRouter) -> UIViewController {
        let presenter = TheatreLocationsPresenter(
            interactor: interactor,
            router: router
        )
        return TheatreLocationsViewController(presenter: presenter)
    }
    
    // MARK: - SwiftUI Builders (Keep for reference/previews)
    
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

// MARK: - Placeholder Router
/// Temporary router used during initialization.
/// Will be replaced with real UIKitRouter once navigation controller exists.
@MainActor
struct PlaceholderRouter: HomeRouter, DetailRouter, FavoritesRouter, TheatreLocationsRouter {
    func showDetailView(delegate: DetailViewDelegate) {
        assertionFailure("PlaceholderRouter should not be used - wire up real router")
    }
    func showFavoritesView() {
        assertionFailure("PlaceholderRouter should not be used - wire up real router")
    }
    func showTheatreLocationsView() {
        assertionFailure("PlaceholderRouter should not be used - wire up real router")
    }
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {
        assertionFailure("PlaceholderRouter should not be used - wire up real router")
    }
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {
        assertionFailure("PlaceholderRouter should not be used - wire up real router")
    }
    func dismissModal() {
        assertionFailure("PlaceholderRouter should not be used - wire up real router")
    }
    func dismissScreen() {
        assertionFailure("PlaceholderRouter should not be used - wire up real router")
    }
}
