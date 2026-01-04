//
//  UIKitRouter.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit

// MARK: - UIKitRouter
/// The UIKit equivalent of your SwiftUI Router/RouterView.
///
/// Key Differences:
/// - SwiftUI Router: Uses @State path array + NavigationStack
/// - UIKit Router: Holds reference to UINavigationController + calls push/present directly
///
/// This class implements all the router protocols (HomeRouter, DetailRouter, etc.)
/// so it can be used throughout the app.

@MainActor
final class UIKitRouter {
    
    // MARK: - Properties
    
    /// The navigation controller that manages the navigation stack.
    /// SwiftUI equivalent: NavigationStack's internal path
    private weak var navigationController: UINavigationController?
    
    /// The builder used to create view controllers.
    /// We need this to create new screens when navigating.
    private let builder: CoreBuilder
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController?, builder: CoreBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    // MARK: - Navigation Helpers
    
    /// Push a view controller onto the navigation stack.
    /// SwiftUI equivalent: router.showScreen(.push) { ... }
    private func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// Present a view controller modally (sheet).
    /// SwiftUI equivalent: router.showScreen(.sheet) { ... }
    private func presentSheet(_ viewController: UIViewController, animated: Bool = true) {
        // Wrap in navigation controller for sheets so they have their own nav bar
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet
        navigationController?.present(navController, animated: animated)
    }
    
    /// Present a view controller as full screen cover.
    /// SwiftUI equivalent: router.showScreen(.fullScreenCover) { ... }
    private func presentFullScreen(_ viewController: UIViewController, animated: Bool = true) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.present(navController, animated: animated)
    }
    
    /// Dismiss the current screen.
    /// SwiftUI equivalent: router.dismissScreen()
    private func dismiss(animated: Bool = true) {
        // Check if we're presented modally or pushed
        if navigationController?.presentedViewController != nil {
            navigationController?.dismiss(animated: animated)
        } else {
            navigationController?.popViewController(animated: animated)
        }
    }
}

// MARK: - HomeRouter Conformance
extension UIKitRouter: HomeRouter {
    
    func showDetailView(delegate: DetailViewDelegate) {
        // Create the detail view controller using the builder
        // Pass self as the router so DetailVC can navigate too
        let detailVC = builder.makeDetailViewController(
            delegate: delegate,
            router: self
        )
        push(detailVC)
    }
}

// MARK: - DetailRouter Conformance
extension UIKitRouter: DetailRouter {
    
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {
        // TODO: Create TrailerModalViewController
        // For now, we'll use a simple alert as placeholder
        let alert = UIAlertController(
            title: "Trailers",
            message: "Trailer modal coming soon!\n\nMovie: \(movie.title ?? "Unknown")",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            onXMarkPressed()
        })
        navigationController?.present(alert, animated: true)
    }
    
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {
        // TODO: Create ImageModalViewController
        let alert = UIAlertController(
            title: "Image Preview",
            message: "Image modal coming soon!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            onXMarkPressed()
        })
        navigationController?.present(alert, animated: true)
    }
    
    func showFavoritesView() {
        let favoritesVC = builder.makeFavoritesViewController(router: self)
        presentSheet(favoritesVC)
    }
    
    func showTheatreLocationsView() {
        let locationsVC = builder.makeTheatreLocationsViewController(router: self)
        presentFullScreen(locationsVC)
    }
    
    func dismissModal() {
        navigationController?.dismiss(animated: true)
    }
    
    func dismissScreen() {
        dismiss()
    }
}

// MARK: - FavoritesRouter Conformance
extension UIKitRouter: FavoritesRouter {
    // showDetailView is already implemented above
}

// MARK: - TheatreLocationsRouter Conformance
extension UIKitRouter: TheatreLocationsRouter {
    // dismissScreen is already implemented above
}

// MARK: - SwiftUI vs UIKit Router Comparison
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │                    NAVIGATION COMPARISON                        │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   SwiftUI (RouterView):              UIKit (UIKitRouter):      │
 │   ─────────────────────              ────────────────────      │
 │                                                                 │
 │   // Push                            // Push                   │
 │   router.showScreen(.push) {         let vc = builder.make()   │
 │       DetailView()                   navController.push(vc)    │
 │   }                                                            │
 │                                                                 │
 │   // Sheet                           // Sheet                  │
 │   router.showScreen(.sheet) {        let vc = builder.make()   │
 │       FavoritesView()                let nav = UINavigation..  │
 │   }                                  navController.present(nav)│
 │                                                                 │
 │   // Dismiss                         // Dismiss                │
 │   router.dismissScreen()             navController.dismiss()   │
 │                                      // or .popViewController  │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   KEY INSIGHT:                                                  │
 │                                                                 │
 │   SwiftUI hides navigation details behind protocols.           │
 │   UIKit requires you to explicitly manage the nav controller.  │
 │                                                                 │
 │   But the VIPER architecture means our Presenters don't care!  │
 │   They just call router.showDetailView() - same API.           │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
