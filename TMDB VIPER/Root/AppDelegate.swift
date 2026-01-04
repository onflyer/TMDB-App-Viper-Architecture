//
//  AppDelegate.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 22. 12. 2024..
//

import UIKit

// MARK: - @main
// This tells iOS "start here". In SwiftUI, @main was on the App struct.
// In UIKit, it's on the AppDelegate class.

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    // These stay the same - your dependency injection setup works perfectly in UIKit
    var dependencies: Dependencies!
    var builder: CoreBuilder!
    
    // MARK: - App Lifecycle
    
    /// Called when the app finishes launching.
    /// This is where you set up everything that needs to exist for the entire app lifetime.
    ///
    /// SwiftUI equivalent: The implicit setup that happens before your App's body is called
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        // Initialize dependencies - same as before!
        dependencies = Dependencies()
        builder = CoreBuilder(interactor: CoreInteractor(container: dependencies.container))
        
        return true
    }
    
    // MARK: - Scene Configuration
    
    /// Tells iOS which SceneDelegate class to use.
    /// Think of this as telling iOS "here's who manages my windows"
    ///
    /// SwiftUI equivalent: WindowGroup automatically handled this for you
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        
        // "Default Configuration" must match what's in Info.plist
        // We'll set that up next
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
    
    /// Called when a scene is discarded (user swipes away from app switcher)
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Clean up any resources specific to discarded scenes
        // Usually empty for simple apps
    }
}

// MARK: - Key Differences from SwiftUI
/*
 
 ┌─────────────────────────────────────────────────────────────────┐
 │                        APP LIFECYCLE                            │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   SwiftUI:                     UIKit:                          │
 │   ─────────                    ──────                          │
 │   @main                        @main                           │
 │   struct App: App {            class AppDelegate {             │
 │       var body: some Scene {       didFinishLaunching() {      │
 │           WindowGroup {                // setup                │
 │               ContentView()        }                           │
 │           }                    }                               │
 │       }                                                        │
 │   }                            + SceneDelegate (manages UI)    │
 │                                                                 │
 ├─────────────────────────────────────────────────────────────────┤
 │                                                                 │
 │   WHY TWO CLASSES?                                             │
 │                                                                 │
 │   AppDelegate  → App-wide concerns (push notifications,        │
 │                  background tasks, app lifecycle)              │
 │                                                                 │
 │   SceneDelegate → UI concerns (windows, view controllers,      │
 │                   foreground/background for each window)       │
 │                                                                 │
 │   This split allows iPad to have multiple windows of your app! │
 │                                                                 │
 └─────────────────────────────────────────────────────────────────┘
 
 */
