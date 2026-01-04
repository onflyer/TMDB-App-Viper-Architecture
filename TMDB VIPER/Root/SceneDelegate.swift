//
//  SceneDelegate.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit

// MARK: - SceneDelegate
/// Manages the app's UI lifecycle for a single "scene" (window).
///
/// SwiftUI equivalent: This is like WindowGroup + the implicit navigation setup

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    /// Keep a reference to the router so it doesn't get deallocated
    var router: UIKitRouter?
    
    // MARK: - Scene Lifecycle
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let builder = appDelegate.builder!
        
        // 1. Create the window
        let window = UIWindow(windowScene: windowScene)
        
        // 2. Create an empty navigation controller first
        let navigationController = UINavigationController()
        
        // 3. Create the router with the navigation controller
        //    This is the KEY STEP - router needs nav controller to push/present
        let router = UIKitRouter(navigationController: navigationController, builder: builder)
        self.router = router  // Keep strong reference
        
        // 4. Now create HomeViewController with the real router
        let homeVC = builder.makeHomeViewController(router: router)
        
        // 5. Set the home VC as root of the navigation controller
        navigationController.viewControllers = [homeVC]
        
        // 6. Set navigation controller as window's root
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        
        print("✅ App started with UIKit navigation")
    }
    
    // MARK: - Scene Lifecycle Events
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // App will come to foreground
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // App became active
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // App will become inactive
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // App entered background
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene was disconnected
    }
}

// MARK: - Setup Flow Diagram
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │                    SETUP FLOW                                   │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   1. UIWindow                                                   │
 │         │                                                       │
 │         ▼                                                       │
 │   2. UINavigationController (empty)                            │
 │         │                                                       │
 │         ▼                                                       │
 │   3. UIKitRouter(navController, builder)                       │
 │         │                                                       │
 │         ▼                                                       │
 │   4. HomeViewController(presenter with router)                 │
 │         │                                                       │
 │         ▼                                                       │
 │   5. navController.viewControllers = [homeVC]                  │
 │         │                                                       │
 │         ▼                                                       │
 │   6. window.rootViewController = navController                 │
 │         │                                                       │
 │         ▼                                                       │
 │   7. window.makeKeyAndVisible() ← App appears!                 │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 WHY THIS ORDER?
 
 The router needs the navigation controller to push/present views.
 The presenter needs the router to handle navigation actions.
 The view controller needs the presenter.
 
 So we create them in this order:
 NavigationController → Router → Presenter → ViewController
 
 */
