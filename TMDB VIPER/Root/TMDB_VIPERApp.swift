//
//  TMDB_VIPERApp.swift
//  TMDB VIPER
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import SwiftUI

@main
struct TMDB_VIPERApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            delegate.builder.homeView()
        }
        
    }
}
