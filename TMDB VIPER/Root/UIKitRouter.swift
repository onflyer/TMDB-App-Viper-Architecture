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
/// IMPORTANT: When presenting sheets/modals that need their own navigation,
/// we create a NEW router for that presented navigation controller.
/// This ensures pushes happen within the sheet, not behind it.

@MainActor
final class UIKitRouter {
    
    // MARK: - Properties
    
    /// The navigation controller that manages the navigation stack.
    private weak var navigationController: UINavigationController?
    
    /// The builder used to create view controllers.
    private let builder: CoreBuilder
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController?, builder: CoreBuilder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    // MARK: - Navigation Helpers
    
    /// Push a view controller onto the navigation stack.
    private func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// Dismiss the current screen.
    private func dismiss(animated: Bool = true) {
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
        let detailVC = builder.makeDetailViewController(delegate: delegate, router: self)
        push(detailVC)
    }
}

// MARK: - DetailRouter Conformance
extension UIKitRouter: DetailRouter {
    
    func showTrailerModalView(movie: SingleMovie, onXMarkPressed: @escaping () -> Void) {
        let trailerVC = TrailerModalViewController(movie: movie, onDismiss: onXMarkPressed)
        let navController = UINavigationController(rootViewController: trailerVC)
        navController.modalPresentationStyle = .pageSheet
        
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        navigationController?.present(navController, animated: true)
    }
    
    func showImageModalView(urlString: String, onXMarkPressed: @escaping () -> Void) {
        let imageVC = ImageModalViewController(imageURLString: urlString, onDismiss: onXMarkPressed)
        navigationController?.present(imageVC, animated: true)
    }
    
    func showFavoritesView() {
        // KEY FIX: Create the sheet's nav controller FIRST
        let sheetNavController = UINavigationController()
        sheetNavController.modalPresentationStyle = .pageSheet
        
        // Create a NEW router that points to the sheet's nav controller
        // This ensures any navigation from FavoritesVC happens WITHIN the sheet
        let sheetRouter = UIKitRouter(navigationController: sheetNavController, builder: builder)
        
        // Create FavoritesVC with the sheet's router
        let favoritesVC = builder.makeFavoritesViewController(router: sheetRouter)
        
        // Set as root of sheet's nav controller
        sheetNavController.viewControllers = [favoritesVC]
        
        // Present the sheet
        navigationController?.present(sheetNavController, animated: true)
    }
    
    func showTheatreLocationsView() {
        // Same pattern for full screen presentation
        let fullScreenNavController = UINavigationController()
        fullScreenNavController.modalPresentationStyle = .fullScreen
        
        // Create router for the full screen nav controller
        let fullScreenRouter = UIKitRouter(navigationController: fullScreenNavController, builder: builder)
        
        // Create VC with that router
        let locationsVC = builder.makeTheatreLocationsViewController(router: fullScreenRouter)
        
        // Set as root and present
        fullScreenNavController.viewControllers = [locationsVC]
        navigationController?.present(fullScreenNavController, animated: true)
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
    // showDetailView is already implemented in HomeRouter
    // When called from FavoritesVC, it will use the sheet's router (sheetRouter)
    // which points to sheetNavController, so DetailVC pushes WITHIN the sheet ✅
}

// MARK: - TheatreLocationsRouter Conformance
extension UIKitRouter: TheatreLocationsRouter {
    // dismissScreen is already implemented above
}

// MARK: - Navigation Flow Diagram
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │              SHEET NAVIGATION FIX                               │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   BEFORE (Bug):                                                │
 │   ─────────────                                                │
 │                                                                 │
 │   MainNavController ←── mainRouter                             │
 │       └── HomeVC                                               │
 │       └── DetailVC (pushed here incorrectly!)                  │
 │                                                                 │
 │   SheetNavController (presented)                               │
 │       └── FavoritesVC (uses mainRouter) ← WRONG!              │
 │                                                                 │
 │   When FavoritesVC called router.showDetailView():            │
 │   → mainRouter.push(DetailVC)                                  │
 │   → Pushed to MainNavController (behind sheet!)               │
 │                                                                 │
 │                                                                 │
 │   AFTER (Fixed):                                               │
 │   ──────────────                                               │
 │                                                                 │
 │   MainNavController ←── mainRouter                             │
 │       └── HomeVC                                               │
 │                                                                 │
 │   SheetNavController ←── sheetRouter (NEW!)                   │
 │       └── FavoritesVC (uses sheetRouter) ← CORRECT!           │
 │       └── DetailVC (pushed here correctly!)                   │
 │                                                                 │
 │   When FavoritesVC calls router.showDetailView():             │
 │   → sheetRouter.push(DetailVC)                                │
 │   → Pushed to SheetNavController (inside sheet!) ✅           │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
