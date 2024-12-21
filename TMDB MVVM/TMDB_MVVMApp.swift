//
//  TMDB_MVVMApp.swift
//  TMDB MVVM
//
//  Created by Aleksandar Milidrag on 21. 12. 2024..
//

import SwiftUI

@main
struct TMDB_MVVMApp: App {
    
    @Environment(DependencyContainer.self) private var container
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

protocol AppRootViewInteractor {
    //MARK: Example for decopling viewModels from all dependancies, this viewModel needs just log in from dependencies and this is the template
    func logIn()
}

extension CoreInteractor: AppRootViewInteractor { }
//MARK: When we conform to AppRootViewInteractor we make possible to use only one function that we need but Core interactor has to have that function inside

class AppRootViewModel {
    
}


