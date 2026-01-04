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
///
/// Key responsibility: Create the UIWindow and set its rootViewController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    /// The window that displays your app's content.
    /// In SwiftUI, you never see this - it's created automatically.
    /// In UIKit, YOU own it and must set it up.
    var window: UIWindow?
    
    // MARK: - Scene Lifecycle
    
    /// Called when a new scene is being created.
    /// THIS IS WHERE YOUR UI STARTS.
    ///
    /// SwiftUI equivalent:
    /// ```
    /// WindowGroup {
    ///     NavigationStack {
    ///         HomeView()
    ///     }
    /// }
    /// ```
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // 1. Make sure we have a window scene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2. Get the builder from AppDelegate
        //    This is how we access app-wide dependencies from SceneDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let builder = appDelegate.builder!
        
        // 3. Create the window
        //    SwiftUI does this automatically with WindowGroup
        let window = UIWindow(windowScene: windowScene)
        
        // 4. Create the root view controller using the builder
        //    We'll update CoreBuilder to return UIViewController soon
        let homeViewController = builder.makeHomeViewController()
        
        // 5. Wrap in UINavigationController
        //    SwiftUI equivalent: NavigationStack { ... }
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        // 6. Set as root and display
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // 7. Keep a reference to the window
        self.window = window
    }
    
    // MARK: - Additional Scene Lifecycle Methods
    
    /// Called when the scene moves from background to foreground
    /// SwiftUI equivalent: .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification))
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Refresh data, restart animations, etc.
    }
    
    /// Called when the scene becomes active (ready for user interaction)
    /// SwiftUI equivalent: .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification))
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Resume paused tasks, start timers, etc.
    }
    
    /// Called when the scene is about to move to background
    /// SwiftUI equivalent: .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification))
    func sceneWillResignActive(_ scene: UIScene) {
        // Pause ongoing tasks, save state, etc.
    }
    
    /// Called when the scene enters background
    /// SwiftUI equivalent: .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification))
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data, release shared resources, etc.
    }
    
    /// Called when the scene is being destroyed
    func sceneDidDisconnect(_ scene: UIScene) {
        // Release any resources specific to this scene
    }
}

// MARK: - Visual Explanation
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │                    UIKIT APP STRUCTURE                          │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   ┌─────────────┐                                              │
 │   │ AppDelegate │ ← App launches here (@main)                  │
 │   └──────┬──────┘                                              │
 │          │                                                      │
 │          │ creates                                              │
 │          ▼                                                      │
 │   ┌───────────────┐                                            │
 │   │ SceneDelegate │ ← Manages UI for one window                │
 │   └───────┬───────┘                                            │
 │           │                                                     │
 │           │ creates                                             │
 │           ▼                                                     │
 │   ┌──────────────┐                                             │
 │   │   UIWindow   │ ← The actual window on screen               │
 │   └───────┬──────┘                                             │
 │           │                                                     │
 │           │ rootViewController                                  │
 │           ▼                                                     │
 │   ┌────────────────────────┐                                   │
 │   │ UINavigationController │ ← Manages navigation stack        │
 │   └───────────┬────────────┘   (like NavigationStack)          │
 │               │                                                 │
 │               │ root                                            │
 │               ▼                                                 │
 │   ┌────────────────────┐                                       │
 │   │ HomeViewController │ ← Your first screen                   │
 │   └────────────────────┘                                       │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 COMPARISON TO YOUR SWIFTUI CODE:
 
 // SwiftUI (TMDB_VIPERApp.swift)
 @main
 struct TMDB_VIPERApp: App {
     var body: some Scene {
         WindowGroup {                          ← SceneDelegate.scene()
             delegate.builder.homeView()        ← builder.makeHomeViewController()
         }
     }
 }
 
 // Your homeView() wraps in RouterView which has NavigationStack
 // In UIKit, we explicitly create UINavigationController
 
 */
