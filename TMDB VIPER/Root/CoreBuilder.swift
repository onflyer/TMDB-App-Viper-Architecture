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
    
    /// Creates the HomeViewController - the main entry point.
    /// Called from SceneDelegate to set up the initial screen.
    ///
    /// Note: This method creates the router internally since it's the root.
    /// Child view controllers receive the router as a parameter.
    func makeHomeViewController(navigationController: UINavigationController? = nil) -> UIViewController {
        // We'll set the router after we have the navigation controller
        // For now, create with a temporary router - SceneDelegate will set the real one
        let presenter = HomePresenter(
            interactor: interactor,
            router: PlaceholderRouter()
        )
        let viewController = HomeViewController(presenter: presenter)
        
        // Store builder reference so we can create router later
        viewController.builder = self
        
        return viewController
    }
    
    /// Creates HomeViewController with a proper router.
    /// Used when we have access to the navigation controller.
    func makeHomeViewController(router: UIKitRouter) -> UIViewController {
        let presenter = HomePresenter(
            interactor: interactor,
            router: router
        )
        return HomeViewController(presenter: presenter)
    }
    
    /// Creates the DetailViewController for showing movie details.
    func makeDetailViewController(
        delegate: DetailViewDelegate = DetailViewDelegate(),
        router: UIKitRouter
    ) -> UIViewController {
        let presenter = DetailPresenter(
            interactor: interactor,
            router: router
        )
        return DetailViewController(presenter: presenter, delegate: delegate)
    }
    
    /// Creates the FavoritesViewController for showing saved movies.
    func makeFavoritesViewController(router: UIKitRouter) -> UIViewController {
        let presenter = FavoritesPresenter(
            interactor: interactor,
            router: router
        )
        // TODO: Create actual FavoritesViewController
        return PlaceholderViewController(title: "Favorites", subtitle: "FavoritesViewController coming soon!")
    }
    
    /// Creates the TheatreLocationsViewController for showing nearby theaters.
    func makeTheatreLocationsViewController(router: UIKitRouter) -> UIViewController {
        let presenter = TheatreLocationsPresenter(
            interactor: interactor,
            router: router
        )
        // TODO: Create actual TheatreLocationsViewController
        return PlaceholderViewController(title: "Nearby Theaters", subtitle: "TheatreLocationsViewController coming soon!")
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
private struct PlaceholderRouter: HomeRouter, DetailRouter, FavoritesRouter, TheatreLocationsRouter {
    func showDetailView(delegate: DetailViewDelegate) {
        print("⚠️ PlaceholderRouter: showDetailView - router not yet configured")
    }
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {}
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {}
    func showFavoritesView() {}
    func showTheatreLocationsView() {}
    func dismissModal() {}
    func dismissScreen() {}
}

// MARK: - Placeholder ViewController
/// Simple placeholder VC for screens we haven't built yet.
/// Makes it easy to test navigation without implementing every screen.
class PlaceholderViewController: UIViewController {
    
    private let titleText: String
    private let subtitleText: String
    
    init(title: String, subtitle: String) {
        self.titleText = title
        self.subtitleText = subtitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = titleText
        
        let label = UILabel()
        label.text = "🚧\n\n\(subtitleText)"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
